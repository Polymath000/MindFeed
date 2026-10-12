import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:hive/hive.dart' show Hive;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/core/constants/constants.dart' show AppConstants;
import 'package:mind_feed/core/database/cache/cache_helper.dart'
    show CacheHelper;
import 'package:mind_feed/core/networking/network_info.dart';
import 'package:mind_feed/features/auth/data/datasources/auth_api_source.dart'
    show AuthApiSource;
import 'package:mind_feed/features/auth/data/datasources/user_cache_source.dart';
import 'package:mind_feed/features/splash/domain/usecases/check_app_startup_use_case.dart';
import 'package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_cubit.dart';
import 'package:mind_feed/features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/auth/data/repos/auth_repo_impl.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  getIt.registerLazySingleton<AuthApiSource>(
    () => AuthApiSource(supabaseClient: getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(supabaseClient: getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<NetworkInfoImpl>(
    () => NetworkInfoImpl(Connectivity()),
  );
  getIt.registerLazySingleton<CheckAppStartupUseCase>(
    () => const CheckAppStartupUseCase(),
  );
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(checkAppStartupUseCase: getIt<CheckAppStartupUseCase>()),
  );
  if (Hive.isBoxOpen(AppConstants.userKey)) {
    getIt.registerLazySingleton<UserCacheDataSource>(
      () => UserCacheDataSource(
        cacheHelper: CacheHelper(kBoxName: AppConstants.userKey),
      ),
    );
    getIt.registerLazySingleton<AuthRepoImpl>(
      () => AuthRepoImpl(
        authApiSource: getIt.get<AuthApiSource>(),
        networkInfo: getIt.get<NetworkInfoImpl>(),
        userCacheDataSource: getIt<UserCacheDataSource>(),
      ),
    );
  }
}
