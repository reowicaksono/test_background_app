import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_background_service/core/constant/app_constant.dart';

class TokenInterceptor {
  const TokenInterceptor({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  Future<Map<String, String>> addAuthHeader(
    Map<String, String>? headers,
  ) async {
    final token = await secureStorage.read(key: AppConstants.tokenKey);
    if (token == null || token.isEmpty) {
      return headers ?? <String, String>{};
    }

    return {...?headers, 'Authorization': 'Bearer $token'};
  }

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await secureStorage.write(key: AppConstants.tokenKey, value: accessToken);
    if (refreshToken != null) {
      await secureStorage.write(
        key: AppConstants.refreshTokenKey,
        value: refreshToken,
      );
    }
  }

  Future<String?> getAccessToken() =>
      secureStorage.read(key: AppConstants.tokenKey);

  Future<String?> getRefreshToken() =>
      secureStorage.read(key: AppConstants.refreshTokenKey);

  Future<void> clearTokens() async {
    await secureStorage.delete(key: AppConstants.tokenKey);
    await secureStorage.delete(key: AppConstants.refreshTokenKey);
  }
}
