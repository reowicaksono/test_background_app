import 'package:equatable/equatable.dart';
import 'package:test_background_service/core/types/type.dart';
import 'package:test_background_service/core/usecase/usecase.dart';
import 'package:test_background_service/features/transaction/domain/entities/transaction_entities.dart';
import 'package:test_background_service/features/transaction/domain/repositories/transaction_repositories.dart';

class SendnotificationUsecase
    extends UsecaseWithParams<TransactionEntities, SendNotificationParams> {
  final TransactionRepositories repositories;

  SendnotificationUsecase({required this.repositories});

  @override
  FutureResult<TransactionEntities> call(SendNotificationParams params) {
    return repositories.sendNotification(
      fcmToken: params.fcmToken,
      transaction: params.transaction,
    );
  }
}

class SendNotificationParams extends Equatable {
  final String fcmToken;
  final TransactionEntities transaction;

  SendNotificationParams({required this.fcmToken, required this.transaction});

  @override
  List<Object?> get props => [fcmToken, transaction];
}
