import 'package:test_background_service/app/logger/app_logger.dart';
import 'package:test_background_service/app/logger/enum_logger.dart';
import 'package:test_background_service/core/types/type.dart';
import 'package:test_background_service/core/utils/either.dart';
import 'package:test_background_service/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:test_background_service/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:test_background_service/features/transaction/domain/entities/transaction_entities.dart';
import 'package:test_background_service/features/transaction/domain/repositories/transaction_repositories.dart';

class TransactionRepositoriesImpl implements TransactionRepositories {
  const TransactionRepositoriesImpl({required this.remoteDatasource});
  final TransactionRemoteDatasource remoteDatasource;
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
}
