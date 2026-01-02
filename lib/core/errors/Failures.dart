import 'dart:io';

class SystemFailureStatusCode {
  static int unknownError = 0;
  static int networkError = 1;
  static int databaseError = 2;
  static int parsingError = 4;
  static int valueError = 5;
  static int noFailure = 99;

  static int authError = HttpStatus.unauthorized;
  static int notFound = HttpStatus.notFound;
}

class Failure {
  final int statusCode;
  final String message;

  const Failure({required this.statusCode, required this.message});

  String getMessage() {
    return 'Error: $message (code: $statusCode)';
  }
}

class NoFailure extends Failure {
  const NoFailure() : super(statusCode: 99, message: 'all good');
}
