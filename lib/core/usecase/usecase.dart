import 'package:test_background_service/core/types/type.dart';

abstract class UsecaseWithParams<Type, Params> {
  const UsecaseWithParams();
  FutureResult<Type> call(Params params);
}

abstract class UseCaseWithoutParams<Type> {
  const UseCaseWithoutParams();
  FutureResult<Type> call();
}
