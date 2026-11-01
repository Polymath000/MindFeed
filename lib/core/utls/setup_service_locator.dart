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
import 'package:mind_feed/features/auth/domain/usecases/verify_recovery_otp_use_case.dart';
import 'package:mind_feed/features/auth/presentation/controllers/change_password_cubit/change_password_cubit.dart';
import 'package:mind_feed/features/auth/presentation/controllers/forget_password_cubit/forget_password_cubit.dart';
import 'package:mind_feed/features/collections/presentation/controllers/collections_cubit.dart';
import 'package:mind_feed/features/collections/presentation/controllers/downloads/downloads_cubit.dart';
import 'package:mind_feed/core/articles/data/datasources/articles_local_data_source.dart';
import 'package:mind_feed/core/articles/data/datasources/articles_remote_data_source.dart';
import 'package:mind_feed/core/articles/data/repos/articles_repo_impl.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/delete_article_use_case.dart';
import 'package:mind_feed/features/collections/domain/usecases/delete_downloaded_article_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/get_article_details_use_case.dart';
import 'package:mind_feed/features/search/domain/usecases/get_articles_by_category_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_downloaded_articles_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/publish_article_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/save_draft_use_case.dart';
import 'package:mind_feed/features/search/domain/usecases/search_articles_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_bookmark_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_star_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/rate_author_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/toggle_article_like_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/filter_articles_by_topic_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_user_feed_topics_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/update_article_use_case.dart';
import 'package:mind_feed/features/article/presentation/controllers/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/home/presentation/controllers/home_feed/home_feed_cubit.dart';
import 'package:mind_feed/features/main/presentation/controllers/main_shell_cubit/main_shell_cubit.dart';
import 'package:mind_feed/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mind_feed/features/profile/data/repos/profile_repo_impl.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/profile/domain/usecases/check_user_has_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/reconcile_category_sync_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/save_favorite_categories_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/categories_cubit/categories_cubit.dart';
import 'package:mind_feed/features/settings/domain/usecases/clear_downloaded_articles_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_archive_cache_size_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_settings_profile_use_case.dart';
import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';
import 'package:mind_feed/features/splash/domain/usecases/check_app_startup_use_case.dart';
import 'package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_cubit.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_tag_use_case.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';
import 'package:mind_feed/features/add_article/domain/usecases/upload_article_cover_image_use_case.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/drafts_cubit/drafts_cubit.dart';
import 'package:mind_feed/features/search/presentation/controllers/search_cubit.dart';
import 'package:mind_feed/features/search/presentation/controllers/tag_articles_cubit/tag_articles_cubit.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_cubit.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_favorite_categories_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:mind_feed/features/profile/domain/usecases/upload_profile_avatar_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_info_cubit.dart';
import 'package:mind_feed/features/article/domain/usecases/check_article_downloaded_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_liked_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_saved_use_case.dart';
import 'package:mind_feed/features/article/domain/usecases/is_article_starred_use_case.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  getIt.registerLazySingleton<SupabaseStorageService>(
    () => SupabaseStorageService(supabaseClient: getIt<SupabaseClient>()),
  );
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
  getIt.registerLazySingleton<VerifyRecoveryOtpUseCase>(
    () => VerifyRecoveryOtpUseCase(repo: getIt<AuthRepository>()),
  );
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(forgetPasswordUseCase: getIt<ForgetPasswordUseCase>()),
  );
  getIt.registerFactory<ChangePasswordCubit>(
    () => ChangePasswordCubit(updatePasswordUseCase: getIt<UpdatePasswordUseCase>()),
  );
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      supabaseClient: getIt<SupabaseClient>(),
      storageService: getIt<SupabaseStorageService>(),
    ),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepoImpl(remoteDataSource: getIt<ProfileRemoteDataSource>()),
  );
  getIt.registerLazySingleton<CheckAppStartupUseCase>(
    () => CheckAppStartupUseCase(authRepository: getIt<AuthRepository>()),
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
  getIt.registerLazySingleton<ReconcileCategorySyncUseCase>(
    () => ReconcileCategorySyncUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerFactory<MainShellCubit>(
    () => MainShellCubit(
      reconcileCategorySyncUseCase: getIt<ReconcileCategorySyncUseCase>(),
    ),
  );
  getIt.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(
      saveFavoriteCategoriesUseCase: getIt<SaveFavoriteCategoriesUseCase>(),
    ),
  );
  getIt.registerLazySingleton<ArticlesLocalDataSource>(
    () => ArticlesLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<OfflineArticlesRepository>(
    () => getIt<ArticlesLocalDataSource>(),
  );
  getIt.registerLazySingleton<ArticlesRemoteDataSource>(
    () => ArticlesRemoteDataSourceImpl(
      supabaseClient: getIt<SupabaseClient>(),
      storageService: getIt<SupabaseStorageService>(),
    ),
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
  getIt.registerLazySingleton<GetFixedTagsUseCase>(
    () => GetFixedTagsUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<UpdateArticleUseCase>(
    () => UpdateArticleUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<UploadArticleCoverImageUseCase>(
    () => UploadArticleCoverImageUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<ArticleEngagementRepository>(
    () => getIt<ArticlesRepository>() as ArticleEngagementRepository,
  );
  getIt.registerLazySingleton<ToggleArticleLikeUseCase>(
    () => ToggleArticleLikeUseCase(getIt<ArticleEngagementRepository>()),
  );
  getIt.registerLazySingleton<RateAuthorUseCase>(
    () => RateAuthorUseCase(getIt<ArticleEngagementRepository>()),
  );
  getIt.registerLazySingleton<GetAuthorRatingUseCase>(
    () => GetAuthorRatingUseCase(getIt<ArticleEngagementRepository>()),
  );
  getIt.registerLazySingleton<GetUserFeedTopicsUseCase>(
    () => GetUserFeedTopicsUseCase(profileRepository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<FilterArticlesByTopicUseCase>(
    () => const FilterArticlesByTopicUseCase(),
  );
  getIt.registerFactory<HomeFeedCubit>(
    () => HomeFeedCubit(
      getHomeFeedUseCase: getIt<GetHomeFeedUseCase>(),
      getUserFeedTopicsUseCase: getIt<GetUserFeedTopicsUseCase>(),
      getSavedArticlesUseCase: getIt<GetSavedArticlesUseCase>(),
      toggleBookmarkUseCase: getIt<ToggleBookmarkUseCase>(),
      toggleStarUseCase: getIt<ToggleStarUseCase>(),
      toggleArticleLikeUseCase: getIt<ToggleArticleLikeUseCase>(),
    ),
  );
  getIt.registerLazySingleton<CheckArticleDownloadedUseCase>(
    () => CheckArticleDownloadedUseCase(getIt<OfflineArticlesRepository>()),
  );
  getIt.registerLazySingleton<IsArticleLikedUseCase>(
    () => IsArticleLikedUseCase(getIt<ArticleEngagementRepository>()),
  );
  getIt.registerLazySingleton<IsArticleSavedUseCase>(
    () => IsArticleSavedUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton<IsArticleStarredUseCase>(
    () => IsArticleStarredUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerFactory<ArticleReaderCubit>(
    () => ArticleReaderCubit(
      getArticleDetailsUseCase: getIt<GetArticleDetailsUseCase>(),
      checkArticleDownloadedUseCase: getIt<CheckArticleDownloadedUseCase>(),
      downloadArticleTextUseCase: getIt<DownloadArticleTextUseCase>(),
      isArticleLikedUseCase: getIt<IsArticleLikedUseCase>(),
      toggleArticleLikeUseCase: getIt<ToggleArticleLikeUseCase>(),
      isArticleSavedUseCase: getIt<IsArticleSavedUseCase>(),
      toggleBookmarkUseCase: getIt<ToggleBookmarkUseCase>(),
      rateAuthorUseCase: getIt<RateAuthorUseCase>(),
      getAuthorRatingUseCase: getIt<GetAuthorRatingUseCase>(),
      toggleStarUseCase: getIt<ToggleStarUseCase>(),
      isArticleStarredUseCase: getIt<IsArticleStarredUseCase>(),
    ),
  );
  getIt.registerFactory<DownloadsCubit>(
    () => DownloadsCubit(
      getDownloadedArticlesUseCase: getIt<GetDownloadedArticlesUseCase>(),
      deleteDownloadedArticleUseCase: getIt<DeleteDownloadedArticleUseCase>(),
    ),
  );
  getIt.registerFactory<CollectionsCubit>(
    () => CollectionsCubit(
      getSavedArticlesUseCase: getIt<GetSavedArticlesUseCase>(),
      toggleBookmarkUseCase: getIt<ToggleBookmarkUseCase>(),
    ),
  );
  getIt.registerLazySingleton<GetSettingsProfileUseCase>(
    () => GetSettingsProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<GetArchiveCacheSizeUseCase>(
    () => GetArchiveCacheSizeUseCase(getIt<GetDownloadedArticlesUseCase>()),
  );
  getIt.registerLazySingleton<ClearDownloadedArticlesUseCase>(
    () => ClearDownloadedArticlesUseCase(getIt<OfflineArticlesRepository>()),
  );
  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(
      getSettingsProfileUseCase: getIt<GetSettingsProfileUseCase>(),
      getArchiveCacheSizeUseCase: getIt<GetArchiveCacheSizeUseCase>(),
      clearDownloadedArticlesUseCase: getIt<ClearDownloadedArticlesUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );
  getIt.registerLazySingleton<GetArticlesByAuthorUseCase>(
    () => GetArticlesByAuthorUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerFactory<DraftsCubit>(
    () => DraftsCubit(
      getArticlesByAuthorUseCase: getIt<GetArticlesByAuthorUseCase>(),
      deleteArticleUseCase: getIt<DeleteArticleUseCase>(),
    ),
  );
  getIt.registerFactory<AddArticleCubit>(
    () => AddArticleCubit(
      getCategoriesUseCase: getIt<GetCategoriesUseCase>(),
      getFixedTagsUseCase: getIt<GetFixedTagsUseCase>(),
      saveDraftUseCase: getIt<SaveDraftUseCase>(),
      publishArticleUseCase: getIt<PublishArticleUseCase>(),
      updateArticleUseCase: getIt<UpdateArticleUseCase>(),
      uploadArticleCoverImageUseCase: getIt<UploadArticleCoverImageUseCase>(),
    ),
  );
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(
      searchArticlesUseCase: getIt<SearchArticlesUseCase>(),
      getArticlesByCategoryUseCase: getIt<GetArticlesByCategoryUseCase>(),
      getCategoriesUseCase: getIt<GetCategoriesUseCase>(),
      getFixedTagsUseCase: getIt<GetFixedTagsUseCase>(),
    ),
  );
  getIt.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<GetFavoriteCategoriesUseCase>(
    () => GetFavoriteCategoriesUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<UploadProfileAvatarUseCase>(
    () => UploadProfileAvatarUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerFactory<ProfileArticlesCubit>(
    () => ProfileArticlesCubit(
      getArticlesByAuthorUseCase: getIt<GetArticlesByAuthorUseCase>(),
      deleteArticleUseCase: getIt<DeleteArticleUseCase>(),
    ),
  );
  getIt.registerFactory<ProfileInfoCubit>(
    () => ProfileInfoCubit(
      getUserProfileUseCase: getIt<GetUserProfileUseCase>(),
      getFavoriteCategoriesUseCase: getIt<GetFavoriteCategoriesUseCase>(),
      getArticlesByAuthorUseCase: getIt<GetArticlesByAuthorUseCase>(),
      uploadProfileAvatarUseCase: getIt<UploadProfileAvatarUseCase>(),
    ),
  );
  getIt.registerLazySingleton<GetArticlesByTagUseCase>(
    () => GetArticlesByTagUseCase(getIt<ArticlesRepository>()),
  );
  getIt.registerFactory<TagArticlesCubit>(
    () => TagArticlesCubit(
      getArticlesByTagUseCase: getIt<GetArticlesByTagUseCase>(),
    ),
  );
  getIt.registerFactory<AuthorCubit>(
    () => AuthorCubit(
      getHomeFeedUseCase: getIt<GetHomeFeedUseCase>(),
      getArticlesByAuthorUseCase: getIt<GetArticlesByAuthorUseCase>(),
    ),
  );
}
