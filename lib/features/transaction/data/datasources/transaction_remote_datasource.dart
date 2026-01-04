import 'package:test_background_service/app/logger/app_logger.dart';
import 'package:test_background_service/app/logger/enum_logger.dart';
import 'package:test_background_service/core/config/environment_config.dart';
import 'package:test_background_service/core/errors/Failures.dart';
import 'package:test_background_service/core/network/api_client_repositories.dart';
import 'package:test_background_service/core/types/type.dart';
import 'package:test_background_service/core/utils/either.dart';
import 'package:test_background_service/features/transaction/data/models/transaction_model.dart';

abstract class TransactionRemoteDatasource {
  FutureResult<TransactionModel> sendNotification({
    required String fcmToken,
    required TransactionModel transaction,
  });
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  TransactionRemoteDatasourceImpl({required this.client});

  final ApiClient client;
  final String apiKey = EnvironmentConfig.apiKey;

  @override
  FutureResult<TransactionModel> sendNotification({
    required String fcmToken,
    required TransactionModel transaction,
  }) async {
    final result = await client.post(
      '/send_notification.php',
      body: {'fcm_token': fcmToken, 'transaction': transaction.toJson()},
      headers: {'X-API-KEY': apiKey},
    );

    return result.fold(
      (failure) {
        AppLogger.log(
          "Failed to send notification ${failure.message}",
          level: LogLevel.error,
          error: failure,
          tag: "Transaction Remote",
        );
        return Either.left(failure);
      },
      (response) {
        final data = response.data;
        if (data == null) {
          AppLogger.log(
            "Data not found in response",
            level: LogLevel.warning,
            tag: "Transaction Remote",
          );
          return Either.left(
            Failure(
              message: 'Data not found',
              statusCode: SystemFailureStatusCode.valueError,
            ),
          );
        }

        try {
          if (data is! DataMap) {
            AppLogger.log(
              "Invalid data format: expected Map",
              level: LogLevel.error,
              tag: "Transaction Remote",
            );
            return Either.left(
              Failure(
                message: 'Invalid data format: expected Map',
                statusCode: SystemFailureStatusCode.parsingError,
              ),
            );
          }
          AppLogger.log(
            "Data found in response",
            error: data.toString(),
            level: LogLevel.info,
            tag: "Transaction Remote",
          );
          return Either.right(TransactionModel.fromJson(data));
        } catch (e) {
          return Either.left(
            Failure(
              message: 'Failed to parse data: ${e.toString()}',
              statusCode: SystemFailureStatusCode.parsingError,
            ),
          );
        }
      },
    );
  }
}
