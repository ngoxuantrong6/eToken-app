import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'core/network/network_info.dart';
import 'core/network/api_service.dart';
import 'features/auth/data/datasource/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/etoken/data/datasource/etoken_local_datasource.dart';
import 'features/etoken/data/datasource/etoken_remote_datasource.dart';
import 'features/etoken/data/repositories/etoken_repository_impl.dart';
import 'features/etoken/domain/repositories/etoken_repository.dart';
import 'features/etoken/domain/usecases/generate_etoken.dart';
import 'features/etoken/domain/usecases/register_etoken.dart';
import 'features/etoken/presentation/bloc/etoken_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => ApiService(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  //! Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      sharedPreferences: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: sl()),
  );

  //! Features - eToken
  // Bloc
  sl.registerFactory(
    () => ETokenBloc(registerEToken: sl(), generateEToken: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => RegisterEToken(sl()));
  sl.registerLazySingleton(() => GenerateEToken(sl()));
  // Repository
  sl.registerLazySingleton<ETokenRepository>(
    () => ETokenRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<ETokenRemoteDataSource>(
    () => ETokenRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<ETokenLocalDataSource>(
    () => ETokenLocalDataSourceImpl(sharedPreferences: sl()),
  );
}

// Mocking NetworkInfo for the sake of the sample
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected => Future.value(true);
}
