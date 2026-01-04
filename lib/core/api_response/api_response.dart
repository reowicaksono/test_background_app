import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiResponse {
  final ApiResponseStatus status;
  final dynamic data;
  final dynamic metadata;

  ApiResponse({
    required this.status,
    required this.data,
    required this.metadata,
  });

  factory ApiResponse.fromHttpResponse(http.Response response) {
    final jsonRes = jsonDecode(response.body);

    return ApiResponse(
      status: ApiResponseStatus(
        code: response.statusCode,
        message: jsonRes['status']?["message"] ?? "No message",
      ),
      data: jsonRes['data'],
      metadata: jsonRes['metadata'],
    );
  }
}

class ApiResponseStatus {
  final int code;
  final String message;

  ApiResponseStatus({required this.code, required this.message});
}
