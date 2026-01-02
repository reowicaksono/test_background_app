import 'package:test_background_service/core/errors/Failures.dart';
import 'package:test_background_service/core/utils/either.dart';

typedef FutureResult<T> = Future<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
