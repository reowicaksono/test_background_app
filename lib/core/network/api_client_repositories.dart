import 'dart:io';
import 'package:test_background_service/core/api_response/api_response.dart';
import 'package:test_background_service/core/types/type.dart';

abstract class ApiClient {
  String get baseUrl;

  /// Get request
  FutureResult<ApiResponse> get(
    String endpoint, {
    Map<String, String>? headers,
  });

  /// Post request
  FutureResult<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  /// Post multipart/form-data request
  FutureResult<ApiResponse> postMultipart(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, File>? files,
    Map<String, String>? headers,
  });

  /// Put request
  FutureResult<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  /// Delete request
  FutureResult<ApiResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
  });
}
