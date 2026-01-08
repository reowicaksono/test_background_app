import 'package:test_background_service/core/types/type.dart';
import 'package:test_background_service/core/usecase/usecase.dart';
import 'package:test_background_service/features/transaction/domain/repositories/transaction_repositories.dart';

class GetFcmtokenUsecase extends UseCaseWithoutParams<String> {
  final TransactionRepositories repositories;

  GetFcmtokenUsecase({required this.repositories});

  @override
  FutureResult<String> call() async {
    return await repositories.getFcmToken();
  }
}
