import 'package:equatable/equatable.dart';
import 'package:test_background_service/core/types/type.dart';
import 'package:test_background_service/core/usecase/usecase.dart';
import 'package:test_background_service/features/transaction/domain/repositories/transaction_repositories.dart';

class SaveFcmtokenUsecase extends UsecaseWithParams<void, SaveFcmtokenParams> {
  final TransactionRepositories repositories;

  SaveFcmtokenUsecase({required this.repositories});

  @override
  FutureResult<void> call(SaveFcmtokenParams params) {
    return repositories.saveFcmToken(fcmToken: params.fcmToken);
  }
}

class SaveFcmtokenParams extends Equatable {
  final String fcmToken;

  const SaveFcmtokenParams({required this.fcmToken});

  @override
  List<Object> get props => [fcmToken];
}
