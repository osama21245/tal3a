import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/auth/data/data_sources/auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // API Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Data Sources
  getIt.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: getIt<AuthDataSource>()),
  );

  // Cubits
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(authRepository: getIt<AuthRepository>()),
  );
}
