import 'package:data_connection_checker_tv/data_connection_checker.dart'
    show DataConnectionChecker;
import 'package:dio/dio.dart' show Dio;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart' show GetIt;
import 'package:hive/hive.dart' show Hive;
import 'package:mind_feed/core/constants/constants.dart' show userKey;
import 'package:mind_feed/core/database/api/dio_consumer.dart';
import 'package:mind_feed/core/database/cache/cache_helper.dart'
    show CacheHelper;
import 'package:mind_feed/core/network/network_info.dart';
import 'package:mind_feed/features/auth/data/datasources/auth_api_source.dart'
    show AuthApiSource;
import 'package:mind_feed/features/auth/data/datasources/user_cache_source.dart';
import '../../features/auth/data/repos/auth_repo_impl.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<DioConsumer>(() => DioConsumer(dio: Dio()));
  getIt.registerLazySingleton<AuthApiSource>(
    () => AuthApiSource(apiConsumer: getIt.get<DioConsumer>()),
  );
  getIt.registerLazySingleton<NetworkInfoImpl>(
    () => kIsWeb ? NetworkInfoImpl() : NetworkInfoImpl(DataConnectionChecker()),
  );
  if (Hive.isBoxOpen(userKey)) {
    getIt.registerLazySingleton<UserCacheDataSource>(
      () => UserCacheDataSource(cacheHelper: CacheHelper(kBoxName: userKey)),
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
