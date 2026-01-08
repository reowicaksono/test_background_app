import 'package:test_background_service/core/types/type.dart';
import 'package:test_background_service/features/transaction/domain/entities/transaction_entities.dart';

abstract class TransactionRepositories {
  FutureResult<TransactionEntities> sendNotification({
    required String fcmToken,
    required TransactionEntities transaction,
  });
  FutureResult<void> saveFcmToken({required String fcmToken});
  FutureResult<String> getFcmToken();
  FutureResult<void> clearFcmToken();
}
