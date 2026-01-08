import 'package:test_background_service/app/logger/app_logger.dart';
import 'package:test_background_service/app/logger/enum_logger.dart';
import 'package:test_background_service/core/errors/Failures.dart';
import 'package:test_background_service/core/storage/local_storage_impl.dart';
import 'package:test_background_service/core/types/type.dart';
import 'package:test_background_service/core/utils/either.dart';
import 'package:test_background_service/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:test_background_service/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:test_background_service/features/transaction/domain/entities/transaction_entities.dart';
import 'package:test_background_service/features/transaction/domain/repositories/transaction_repositories.dart';

class TransactionRepositoriesImpl implements TransactionRepositories {
  const TransactionRepositoriesImpl({
    required this.remoteDatasource,
    required this.localStorage,
  });
  final TransactionRemoteDatasource remoteDatasource;
  final LocalStorageRepositories localStorage;
  @override
  FutureResult<TransactionEntities> sendNotification({
    required String fcmToken,
    required TransactionEntities transaction,
  }) async {
    final transactionMap = TransactionMapper.toModel(transaction);
    final result = await remoteDatasource.sendNotification(
      fcmToken: fcmToken,
      transaction: transactionMap,
    );

    return result.fold(
      (failure) {
        AppLogger.log(
          "Failed to send notification ${failure.message}",
          level: LogLevel.error,
          error: failure,
          tag: "Transaction Repositories",
        );
        return Either.left(failure);
      },
      (model) {
        AppLogger.log(
          "Successfully sent notification",
          level: LogLevel.info,
          tag: "Transaction Repositories",
          data: model.toJson(),
        );
        return Either.right(TransactionMapper.toEntity(model));
      },
    );
  }

  @override
  FutureResult<void> clearFcmToken() async {
    try {
      await localStorage.clearFcmToken();
      return Either.right(null);
    } catch (e) {
      AppLogger.log(
        "Failed to clear FCM token ${e.toString()}",
        level: LogLevel.error,
        error: e,
        tag: "Transaction Repositories",
      );
      return Either.left(
        Failure(
          message: e.toString(),
          statusCode: SystemFailureStatusCode.unknownError,
        ),
      );
    }
  }

  @override
  FutureResult<String> getFcmToken() async {
    try {
      final fcmToken = await localStorage.getFcmToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        AppLogger.log(
          "FCM token not found",
          level: LogLevel.warning,
          tag: "Transaction Repositories",
        );
        return Either.left(
          Failure(
            message: "FCM token not found",
            statusCode: SystemFailureStatusCode.valueError,
          ),
        );
      }
      AppLogger.log(
        "FCM token found",
        level: LogLevel.info,
        tag: "Transaction Repositories",
        data: fcmToken,
      );
      return Either.right(fcmToken);
    } catch (e) {
      AppLogger.log(
        "Failed to get FCM token ${e.toString()}",
        level: LogLevel.error,
        error: e,
        tag: "Transaction Repositories",
      );
      return Either.left(
        Failure(
          message: e.toString(),
          statusCode: SystemFailureStatusCode.unknownError,
        ),
      );
    }
  }

  @override
  FutureResult<void> saveFcmToken({required String fcmToken}) async {
    try {
      if (fcmToken.isEmpty) {
        AppLogger.log(
          "FCM token is empty",
          level: LogLevel.warning,
          tag: "Transaction Repositories",
        );
        return Either.left(
          Failure(
            message: "FCM token is empty",
            statusCode: SystemFailureStatusCode.valueError,
          ),
        );
      }

      await localStorage.saveFcmToken(fcmToken: fcmToken);

      AppLogger.log(
        "Successfully saved FCM token",
        level: LogLevel.info,
        tag: "Transaction Repositories",
        data: fcmToken,
      );
      return Either.right(null);
    } catch (e) {
      AppLogger.log(
        "Failed to save FCM token ${e.toString()}",
        level: LogLevel.error,
        error: e,
        tag: "Transaction Repositories",
      );
      return Either.left(
        Failure(
          message: e.toString(),
          statusCode: SystemFailureStatusCode.unknownError,
        ),
      );
    }
  }
}
