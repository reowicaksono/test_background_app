import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test_background_service/core/api_response/api_response.dart';
import 'package:test_background_service/core/config/environment_config.dart';
import 'package:test_background_service/core/errors/Failures.dart';
import 'package:test_background_service/core/internet_connectivity/internet_connectivity.dart';
import 'package:test_background_service/core/network/api_client_repositories.dart';
import 'package:test_background_service/core/network/interceptor/interceptor.dart';
import 'package:test_background_service/core/types/type.dart';
import 'package:test_background_service/core/utils/either.dart';

class ApiClientImpl implements ApiClient {
  ApiClientImpl({required this.connectivityRepository, this.tokenInterceptor}) {
    final baseUrl = EnvironmentConfig.baseUrl;
    if (baseUrl.isEmpty) {
      throw Exception('BASE_URL is not set in .env file');
    }
    _baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl';
  }

  final ConnectivityRepository connectivityRepository;
  final TokenInterceptor? tokenInterceptor;
  late final String _baseUrl;

  @override
  String get baseUrl => _baseUrl;

  FutureResult<void> _checkConnectivity() async {
    // ConnectivityRepository already keeps the latest connectivity state.
    // We only need to block the request when the device is offline.
    if (!connectivityRepository.isConnected) {
      return Either.left(
        Failure(
          statusCode: SystemFailureStatusCode.networkError,
          message: 'No internet connection',
        ),
      );
    }
    return Either.right(null);
  }

  @override
  FutureResult<ApiResponse> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final connectivityCheck = await _checkConnectivity();
    return connectivityCheck.fold((failure) => Either.left(failure), (_) async {
      try {
        final uri = Uri.parse('$_baseUrl$endpoint');
        final response = await http.get(
          uri,
          headers: await _buildHeaders(headers),
        );

        return _handleResponse(response);
      } catch (e) {
        return Either.left(
          Failure(
            statusCode: SystemFailureStatusCode.networkError,
            message: 'Get request failed: $e',
          ),
        );
      }
    });
  }

  @override
  FutureResult<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final connectivityCheck = await _checkConnectivity();
    return connectivityCheck.fold((failure) => Either.left(failure), (_) async {
      try {
        final uri = Uri.parse('$_baseUrl$endpoint');
        final response = await http.post(
          uri,
          headers: await _buildHeaders(headers),
          body: body != null ? jsonEncode(body) : null,
        );

        return _handleResponse(response);
      } catch (e) {
        return Either.left(
          Failure(
            statusCode: SystemFailureStatusCode.networkError,
            message: 'Delete request failed: $e',
          ),
        );
      }
    });
  }

  @override
  FutureResult<ApiResponse> postMultipart(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, File>? files,
    Map<String, String>? headers,
  }) async {
    final connectivityCheck = await _checkConnectivity();
    return connectivityCheck.fold((failure) => Either.left(failure), (_) async {
      try {
        final uri = Uri.parse('$_baseUrl$endpoint');
        final request = http.MultipartRequest('POST', uri);

        // Add headers
        request.headers.addAll(
          await _buildHeaders(headers, withJsonContentType: false),
        );

        // Add form fields
        if (fields != null) {
          request.fields.addAll(fields);
        }

        // Add files
        if (files != null) {
          for (final entry in files.entries) {
            if (entry.value.existsSync()) {
              final fileStream = entry.value.openRead();
              final fileLength = await entry.value.length();
              final multipartFile = http.MultipartFile(
                entry.key,
                fileStream,
                fileLength,
                filename: entry.value.path.split('/').last,
              );
              request.files.add(multipartFile);
            }
          }
        }

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        return _handleResponse(response);
      } catch (e) {
        return Either.left(
          Failure(
            statusCode: SystemFailureStatusCode.networkError,
            message: 'Post request failed: $e',
          ),
        );
      }
    });
  }

  @override
  FutureResult<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final connectivityCheck = await _checkConnectivity();
    return connectivityCheck.fold((failure) => Either.left(failure), (_) async {
      try {
        final uri = Uri.parse('$_baseUrl$endpoint');
        final response = await http.put(
          uri,
          headers: await _buildHeaders(headers),
          body: body != null ? jsonEncode(body) : null,
        );

        return _handleResponse(response);
      } catch (e) {
        return Either.left(
          Failure(
            statusCode: SystemFailureStatusCode.networkError,
            message: 'Put request failed: $e',
          ),
        );
      }
    });
  }

  @override
  FutureResult<ApiResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final connectivityCheck = await _checkConnectivity();
    return connectivityCheck.fold((failure) => Either.left(failure), (_) async {
      try {
        final uri = Uri.parse('$_baseUrl$endpoint');
        final response = await http.delete(
          uri,
          headers: await _buildHeaders(headers),
        );

        return _handleResponse(response);
      } catch (e) {
        return Either.left(
          Failure(
            statusCode: SystemFailureStatusCode.networkError,
            message: 'Delete request failed: $e',
          ),
        );
      }
    });
  }

  /// Handle HTTP response
  Either<Failure, ApiResponse> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        if (response.body.isEmpty) {
          return Either.right(ApiResponse.fromHttpResponse(response));
        }
        return Either.right(ApiResponse.fromHttpResponse(response));
      } catch (e) {
        return Either.left(
          Failure(
            statusCode: SystemFailureStatusCode.networkError,
            message: 'json parsing failed: $e',
          ),
        );
      }
    } else if (response.statusCode >= 500) {
      return Either.left(
        Failure(
          statusCode: SystemFailureStatusCode.networkError,
          message: 'Delete request failed',
        ),
      );
    } else {
      try {
        final jsonData = jsonDecode(response.body);

        final message = jsonData['message'] ?? 'Unknown error';
        return Either.left(
          Failure(
            statusCode: SystemFailureStatusCode.networkError,
            message: message,
          ),
        );
      } catch (e) {
        return Either.left(
          Failure(
            statusCode: SystemFailureStatusCode.networkError,
            message: ' Failed to parse response: $e',
          ),
        );
      }
    }
  }

  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? headers, {
    bool withJsonContentType = true,
  }) async {
    final defaultHeaders = <String, String>{
      if (withJsonContentType) 'Content-Type': 'application/json',
      ...?headers,
    };

    if (tokenInterceptor == null) {
      return defaultHeaders;
    }

    return await tokenInterceptor!.addAuthHeader(defaultHeaders);
  }
}
