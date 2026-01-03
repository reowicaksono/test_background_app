import 'package:get_it/get_it.dart';
import 'package:test_background_service/core/interet_connectivity/internet_connectivity.dart';
import 'package:test_background_service/core/network/api_client.dart';
import 'package:test_background_service/core/network/api_client_repositories.dart';
import 'package:http/http.dart' as http;
import 'package:test_background_service/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:test_background_service/features/transaction/data/repositories/transaction_repositories_impl.dart';
import 'package:test_background_service/features/transaction/domain/repositories/transaction_repositories.dart';
import 'package:test_background_service/features/transaction/presentation/bloc/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  sl.registerLazySingleton<ConnectivityRepository>(
    () => ConnectivityRepository(),
  );
  sl.registerLazySingleton<ApiClient>(
    () => ApiClientImpl(connectivityRepository: sl<ConnectivityRepository>()),
  );

  // transaction
  sl.registerLazySingleton<TransactionRemoteDatasource>(
    () => TransactionRemoteDatasourceImpl(client: sl<ApiClient>()),
  );
  sl.registerLazySingleton<TransactionRepositories>(
    () => TransactionRepositoriesImpl(
      remoteDatasource: sl<TransactionRemoteDatasource>(),
    ),
  );
  sl.registerFactory(() => TransactionBloc(sl<TransactionRepositories>()));
}
