import 'package:test_background_service/core/types/type.dart';
import 'package:test_background_service/core/usecase/usecase.dart';
import 'package:test_background_service/features/transaction/domain/repositories/transaction_repositories.dart';

class ClearFcmtokenUsecase extends UseCaseWithoutParams<void> {
  final TransactionRepositories repositories;

  ClearFcmtokenUsecase({required this.repositories});

  @override
  FutureResult<void> call() {
    return repositories.clearFcmToken();
  }
}
