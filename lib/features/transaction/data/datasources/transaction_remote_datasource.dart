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
  const TransactionRemoteDatasourceImpl({required this.client});

  final ApiClient client;

  @override
  FutureResult<TransactionModel> sendNotification({
    required String fcmToken,
    required TransactionModel transaction,
  }) async {
    final result = await client.post(
      '/send-notification.php',
      body: {'fcmToken': fcmToken, 'transaction': transaction.toJson()},
    );

    return result.fold((failure) => Either.left(failure), (response) {
      final data = response.data;
      if (data == null) {
        return Either.left(
          Failure(
            message: 'Data not found',
            statusCode: SystemFailureStatusCode.valueError,
          ),
        );
      }

      try {
        if (data is! DataMap) {
          return Either.left(
            Failure(
              message: 'Invalid data format: expected Map',
              statusCode: SystemFailureStatusCode.parsingError,
            ),
          );
        }
        return Either.right(TransactionModel.fromJson(data));
      } catch (e) {
        return Either.left(
          Failure(
            message: 'Failed to parse data: ${e.toString()}',
            statusCode: SystemFailureStatusCode.parsingError,
          ),
        );
      }
    });
  }
}
