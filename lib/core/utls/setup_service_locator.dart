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
import 'package:mind_feed/features/auth/data/repos/auth_repo_impl.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/auth/domain/usecases/forget_password_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/login_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/resend_otp_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/signup_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/update_password_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:mind_feed/features/auth/presentation/controllers/change_password_cubit/change_password_cubit.dart';
import 'package:mind_feed/features/auth/presentation/controllers/forget_password_cubit/forget_password_cubit.dart';
import 'package:mind_feed/features/home/data/datasources/articles_local_data_source.dart';
import 'package:mind_feed/features/home/data/datasources/articles_remote_data_source.dart';
import 'package:mind_feed/features/home/data/repos/articles_repo_impl.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/delete_article_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/delete_downloaded_article_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_articles_by_category_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_downloaded_articles_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/publish_article_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/save_draft_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/search_articles_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mind_feed/features/profile/data/repos/profile_repo_impl.dart';
import 'package:mind_feed/features/profile/data/services/category_sync_reconciler.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/profile/domain/usecases/check_user_has_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/save_favorite_categories_use_case.dart';
import 'package:mind_feed/features/splash/domain/usecases/check_app_startup_use_case.dart';
import 'package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  getIt.registerLazySingleton<NetworkInfoImpl>(
    () => NetworkInfoImpl(Connectivity()),
  );
  getIt.registerLazySingleton<NetworkInfo>(() => getIt<NetworkInfoImpl>());
  getIt.registerLazySingleton<AuthApiSource>(
    () => AuthApiSource(supabaseClient: getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<UserCacheDataSource>(
    () => UserCacheDataSource(
      cacheHelper: CacheHelper(
        kBoxName: Hive.isBoxOpen(AppConstants.userKey)
            ? AppConstants.userKey
            : '',
      ),
    ),
  );
  getIt.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(
      authApiSource: getIt<AuthApiSource>(),
      networkInfo: getIt<NetworkInfo>(),
      userCacheDataSource: getIt<UserCacheDataSource>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(() => getIt<AuthRepoImpl>());
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repo: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(repo: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(repo: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ResendOtpUseCase>(
    () => ResendOtpUseCase(repo: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ForgetPasswordUseCase>(
    () => ForgetPasswordUseCase(repo: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<UpdatePasswordUseCase>(
    () => UpdatePasswordUseCase(repo: getIt<AuthRepository>()),
  );
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(forgetPasswordUseCase: getIt<ForgetPasswordUseCase>()),
  );
  getIt.registerFactory<ChangePasswordCubit>(
    () => ChangePasswordCubit(updatePasswordUseCase: getIt<UpdatePasswordUseCase>()),
  );
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(supabaseClient: getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepoImpl(remoteDataSource: getIt<ProfileRemoteDataSource>()),
  );
  getIt.registerLazySingleton<CheckAppStartupUseCase>(
    () => CheckAppStartupUseCase(authApiSource: getIt<AuthApiSource>()),
  );
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(checkAppStartupUseCase: getIt<CheckAppStartupUseCase>()),
  );
  getIt.registerLazySingleton<CheckUserHasCategoriesUseCase>(
    () => CheckUserHasCategoriesUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<SaveFavoriteCategoriesUseCase>(
    () => SaveFavoriteCategoriesUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<CategorySyncReconciler>(
    () => CategorySyncReconciler(profileRepository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<ArticlesLocalDataSource>(
    () => ArticlesLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<ArticlesRemoteDataSource>(
    () => ArticlesRemoteDataSourceImpl(supabaseClient: getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<ArticlesRepository>(
    () => ArticlesRepositoryImpl(
      remoteDataSource: getIt<ArticlesRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
      localDataSource: getIt<ArticlesLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(
      authRepo: getIt<AuthRepository>(),
      articlesRepo: getIt<ArticlesRepository>(),
      localDataSource: getIt<ArticlesLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<DownloadArticleTextUseCase>(
    () => DownloadArticleTextUseCase(getIt<ArticlesLocalDataSource>()),
  );
  getIt.registerLazySingleton<GetDownloadedArticlesUseCase>(
    () => GetDownloadedArticlesUseCase(getIt<ArticlesLocalDataSource>()),
  );
  getIt.registerLazySingleton<DeleteDownloadedArticleUseCase>(
    () => DeleteDownloadedArticleUseCase(getIt<ArticlesLocalDataSource>()),
  );
  getIt.registerLazySingleton<GetHomeFeedUseCase>(
    () => GetHomeFeedUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<GetArticleDetailsUseCase>(
    () => GetArticleDetailsUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<SearchArticlesUseCase>(
    () => SearchArticlesUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<GetArticlesByCategoryUseCase>(
    () => GetArticlesByCategoryUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<ToggleStarUseCase>(
    () => ToggleStarUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<ToggleBookmarkUseCase>(
    () => ToggleBookmarkUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<GetSavedArticlesUseCase>(
    () => GetSavedArticlesUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<SaveDraftUseCase>(
    () => SaveDraftUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<PublishArticleUseCase>(
    () => PublishArticleUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<DeleteArticleUseCase>(
    () => DeleteArticleUseCase(getIt<ArticlesRepository>()),
  );
}
