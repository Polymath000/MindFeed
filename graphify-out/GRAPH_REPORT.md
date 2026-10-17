# Graph Report - MindFeed-main  (2026-10-17)

## Corpus Check
- 312 files · ~248,402 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 3221 nodes · 5043 edges · 178 communities (173 shown, 2 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `8398e2cf`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- app_colors.dart
- app_icons.dart
- category_onboarding_clean_architecture_test.dart
- app_text_styles.dart
- setup_service_locator.dart
- editorial_card_stack.dart
- profile_repo_impl.dart
- settings_archive_section.dart
- app_routes.dart
- sign_up_view_body.dart
- app_theme_data.dart
- category_sync_hardening_test.dart
- collections_cubit.dart
- theme_mode_cubit.dart
- Business Requirements Document (BRD)
- home_feed_cubit.dart
- signup_cubit.dart
- auth_repo_impl.dart
- package:flutter/material.dart
- Mini-requirements
- Continuation Packet: S1-editorial-shell-recovery
- package:mind_feed/core/constants/app_icons.dart
- package:mind_feed/core/constants/app_text_styles.dart
- login_cubit.dart
- Task Packet: S1-editorial-shell
- Task Packet: S2-auth-refinement
- categories_view.dart
- settings_tile_primitives.dart
- editorial_design.dart
- splash_test.dart
- auth_repo.dart
- device_preference_notifier.dart
- package:mind_feed/config/routes/app_routes.dart
- borders.dart
- theme_config.dart
- article_reader_cubit_test.dart
- MindFeed Editorial UI Specification & Architecture
- search_cubit_test.dart
- main.dart
- settings_view_body.dart
- Mind Feed
- article_entity.dart
- sign_up_form_body.dart
- onboarding_view_body.dart
- email_confirmation_and_auth_flow_test.dart
- custom_app_bar.dart
- send_code_view_body.dart
- duplicate_signup_test.dart
- constants.dart
- categories_cubit.dart
- StatelessWidget
- custom_drawer.dart
- Fake
- login_category_check_test.dart
- NetworkInfo
- State
- editorial_saved_stack.dart
- shared_preferences_singleton.dart
- on_boarding_background.dart
- main_view.dart
- article_view.dart
- MindFeed Editorial UI Transformation Plan
- Hermes Review Result: S1-editorial-shell
- add_article_cubit_test.dart
- MindFeed Phase 0 — Repository and Live Database Reconciliation Report
- @immutable
- app_images.dart
- article_reader_markdown_body.dart
- package:flutter/foundation.dart
- Orchestration State
- editorial_models.dart
- add_article.dart
- signup_params.dart
- search_cubit.dart
- string_extension.dart
- profile_articles_state.dart
- article_data_and_domain_test.dart
- Design Context
- editorial_stack_test.dart
- package:mind_feed/core/design/editorial_models.dart
- check_code_controller.dart
- Project Context: Mind Feed
- offline_articles_and_logout_test.dart
- add_article_cubit.dart
- package:mind_feed/core/constants/app_colors.dart
- check_code_view_body.dart
- Exception
- login_params.dart
- downloaded_article_entity.dart
- List
- cubit.dart
- 3. Monolithic Files Exceeding 250 Lines
- articles_remote_data_source.dart
- articles_repo_impl.dart
- package:mind_feed/features/auth/domain/entities/user_entity.dart
- articles_repo.dart
- 2. Technical Implementation Boundaries
- auth_api_source.dart
- check_code_actions_section.dart
- home_feed_cubit_test.dart
- settings_cubit.dart
- article_model.dart
- String?
- article_validator.dart
- MindFeed Phase 1 — Database Baseline & Migration Reconciliation Verification Report
- MindFeed Phase 1 — Database Baseline and Migration Reconciliation Report
- fake_articles_repository.dart
- search_filter_chips_bar.dart
- personal_infromation.dart
- change_password_form.dart
- custom_loading_indecator.dart
- failures.dart
- user_cache_source.dart
- package:flutter_bloc/flutter_bloc.dart
- widget_test.dart
- home_masthead_header.dart
- article_reader_deps.dart
- package:mind_feed/core/utls/setup_service_locator.dart
- main_navigation_bar.dart
- add_article_state.dart
- login_form.dart
- check_code_args.dart
- categories_view_test.dart
- package:flutter_test/flutter_test.dart
- forget_password_flow_test.dart
- Cubit
- package:mind_feed/core/networking/api_result.dart
- DraftsCubit
- auth_forms_test.dart
- profile_repo.dart
- editorial_card.dart
- article_reader_header.dart
- downloads_cubit_test.dart
- downloaded_articles_view.dart
- DownloadedArticleEntity
- check_app_startup_use_case.dart
- forget_password_cubit.dart
- downloads_cubit.dart
- password_text_field.dart
- article_reader_state.dart
- datasources/articles_local_data_source.dart
- change_password_cubit.dart
- current_user_session.dart
- downloads_state.dart
- settings_reading_section.dart
- package:mind_feed/core/constants/constants.dart
- add_to_favorite_article_card.dart
- search_view.dart
- splash_logo_widget.dart
- articles_saved.dart
- ArticlesLocalDataSource
- splash_view.dart
- ProfileArticlesCubit
- list_saved_articles.dart
- splash_cubit.dart
- api_result.dart
- home_feed_state.dart
- settings_dialogs.dart
- home_view.dart
- article_field_helpers.dart
- change_password_view.dart
- downloaded_article_card_tile.dart
- package:mind_feed/core/errors/failures.dart
- user_articles_widget_test.dart
- check_code_view.dart
- send_code_view.dart
- search_filter_helper_test.dart
- static const String
- save_favorite_categories_use_case.dart
- SplashCubit
- main_app.dart
- package:mind_feed/features/home/domain/entities/tag_entity.dart
- repos/articles_local_data_source.dart
- package:mind_feed/features/home/presentation/views/article_view.dart
- ArticlesRemoteDataSource

## God Nodes (most connected - your core abstractions)
1. `ArticlesRepository` - 29 edges
2. `AddArticleCubit` - 24 edges
3. `Continuation Packet: S1-editorial-shell-recovery` - 19 edges
4. `Task Packet: S1-editorial-shell` - 18 edges
5. `Task Packet: S2-auth-refinement` - 18 edges
6. `AuthRepository` - 17 edges
7. `ProfileArticlesCubit` - 17 edges
8. `DraftsCubit` - 16 edges
9. `UserEntity` - 16 edges
10. `Mini-requirements` - 16 edges

## Surprising Connections (you probably didn't know these)
- `MockNetworkInfo` --implements--> `NetworkInfo`  [EXTRACTED]
  test/features/home/article_data_and_domain_test.dart → lib/core/networking/network_info.dart
- `FakeNetworkInfo` --implements--> `NetworkInfo`  [EXTRACTED]
  test/offline_articles_and_logout_test.dart → lib/core/networking/network_info.dart
- `_FakeAuthRepo` --implements--> `AuthRepository`  [EXTRACTED]
  test/auth_forms_test.dart → lib/features/auth/domain/repos/auth_repo.dart
- `_FakeAuthRepository` --implements--> `AuthRepository`  [EXTRACTED]
  test/features/auth/forget_password_flow_test.dart → lib/features/auth/domain/repos/auth_repo.dart
- `FakeArticlesRemoteDataSource` --implements--> `ArticlesRemoteDataSource`  [EXTRACTED]
  test/features/home/article_data_and_domain_test.dart → lib/features/home/data/datasources/articles_remote_data_source.dart

## Import Cycles
- None detected.

## Communities (178 total, 2 thin omitted)

### Community 0 - "app_colors.dart"
Cohesion: 0.02
Nodes (120): almostBlack, amber, amberDark, amberDarker, black, blue, blueMain, blush (+112 more)

### Community 1 - "app_icons.dart"
Cohesion: 0.02
Nodes (95): add, alternateEmailRounded, AppIcons, arrowBackRounded, arrowForwardIosRounded, artDesign, articleOutlined, boltRounded (+87 more)

### Community 2 - "category_onboarding_clean_architecture_test.dart"
Cohesion: 0.08
Nodes (24): PostgrestException, categoriesList, clearDownloadedArticles, clearOfflineCalled, from, fromInvoked, getCategories, getFavoriteCategories (+16 more)

### Community 3 - "app_text_styles.dart"
Cohesion: 0.09
Nodes (21): bodyLarge, bodyMedium, bodySmall, displayLarge, displayMedium, displaySmall, headlineLarge, headlineMedium (+13 more)

### Community 4 - "setup_service_locator.dart"
Cohesion: 0.06
Nodes (34): getIt, setupServiceLocator, AuthRepoImpl, AuthRepository, call, ForgetPasswordUseCase, repo, articlesRepo (+26 more)

### Community 5 - "editorial_card_stack.dart"
Cohesion: 0.09
Nodes (22): _animController, build, _cards, createState, didUpdateWidget, dispose, _dragOffset, EditorialCardStack (+14 more)

### Community 6 - "profile_repo_impl.dart"
Cohesion: 0.11
Nodes (16): ../errors/exceptions.dart, ApiErrorHandler, code, handle, message, toFailure, getCategories, getFavoriteCategories (+8 more)

### Community 7 - "settings_archive_section.dart"
Cohesion: 0.08
Nodes (24): build, cachedMegabytes, dataPreservation, onClearCache, onDataPreservationChanged, onSignOut, onWifiOnlyChanged, SettingsArchiveSection (+16 more)

### Community 8 - "app_routes.dart"
Cohesion: 0.05
Nodes (37): addArticle, AppRoutes, article, articlePreview, articlesCategory, articlesSaved, author, categories (+29 more)

### Community 9 - "sign_up_view_body.dart"
Cohesion: 0.10
Nodes (19): build, ChangePasswordViewBody, email, build, LoginViewBody, _handleState, build, SignUpViewBody (+11 more)

### Community 10 - "app_theme_data.dart"
Cohesion: 0.06
Nodes (34): card, checkbox, chip, dialog, dropdownMenu, filledButton, floatingActionButton, iconButton (+26 more)

### Community 11 - "category_sync_hardening_test.dart"
Cohesion: 0.11
Nodes (17): dart:io, Directory, MockProfileRemoteDataSource, package:mind_feed/features/home/data/datasources/articles_local_data_source.dart, categoriesList, clearAllDownloadedArticles, cleared, getCategories (+9 more)

### Community 12 - "collections_cubit.dart"
Cohesion: 0.16
Nodes (18): CollectionsEmpty, CollectionsError, CollectionsInitial, CollectionsLoaded, CollectionsLoading, CollectionsState, message, props (+10 more)

### Community 13 - "theme_mode_cubit.dart"
Cohesion: 0.38
Nodes (9): ThemeModeDark, ThemeModeInitial, ThemeModeLight, ThemeModeState, ThemeModeSystem, changeThemeMode, getThemeMode, ThemeModeCubit (+1 more)

### Community 14 - "Business Requirements Document (BRD)"
Cohesion: 0.08
Nodes (24): 1.1 Purpose, 1.2 Business Problem Statement, 1.3 Vision & Solution, 1. Executive Summary, 2. Business Objectives & Key Performance Indicators (KPIs), 3.1 Competitive Landscape, 3.2 Target Audience Segments, 3. Market Analysis & Value Proposition (+16 more)

### Community 15 - "home_feed_cubit.dart"
Cohesion: 0.12
Nodes (14): home_feed_state.dart, ArticlePayloadBuilder, buildDraftPayload, buildPublishPayload, resolveAuthorName, _currentUserId, fetchFeed, _getHomeFeedUseCase (+6 more)

### Community 16 - "signup_cubit.dart"
Cohesion: 0.21
Nodes (15): email, errorMessage, isUserAlreadyRegistered, SignupFailure, SignupInitial, SignupLoading, SignupRequiresConfirmation, SignupState (+7 more)

### Community 17 - "auth_repo_impl.dart"
Cohesion: 0.13
Nodes (14): authApiSource, cacheHelper, forgetPassword, login, logout, networkInfo, resendOtp, signup (+6 more)

### Community 18 - "package:flutter/material.dart"
Cohesion: 0.06
Nodes (25): customShowSnackBar, duration, authBackground, build, ListForSavedArticles, build, SavedArticlesViewBody, build (+17 more)

### Community 19 - "Mini-requirements"
Cohesion: 0.09
Nodes (21): 1. Mandatory Authentication & Onboarding, 2. Home Feed & Discovery, 3. Article Reader, Starring & Sharing, 4. Offline Mode (Text-Only), 5. Article Drafting, Preview, Publishing & Lifecycle, 6. Personal Collections & Settings, Acceptance Criteria, Business Rules (+13 more)

### Community 20 - "Continuation Packet: S1-editorial-shell-recovery"
Cohesion: 0.10
Nodes (19): Allowed edit scope, Areas that must not be redesigned, Completed work, Continuation objective, Continuation Packet: S1-editorial-shell-recovery, Current failures, Exact files to inspect, Exact remaining work (+11 more)

### Community 21 - "package:mind_feed/core/constants/app_icons.dart"
Cohesion: 0.05
Nodes (36): build, MoreVertIcon, AuthorAppBar, build, build, CustomPopupMenuButtonForSavedArticlesView, build, DownloadedArticlesEmptyState (+28 more)

### Community 22 - "package:mind_feed/core/constants/app_text_styles.dart"
Cohesion: 0.10
Nodes (16): ArticleCardInformation, author, build, date, title, author, build, date (+8 more)

### Community 23 - "login_cubit.dart"
Cohesion: 0.21
Nodes (15): email, errorMessage, LoginFailure, LoginInitial, LoginLoading, LoginRequiresCategories, LoginState, LoginSuccess (+7 more)

### Community 24 - "Task Packet: S1-editorial-shell"
Cohesion: 0.11
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 25 - "Task Packet: S2-auth-refinement"
Cohesion: 0.11
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 26 - "categories_view.dart"
Cohesion: 0.13
Nodes (14): build, _buildCubit, categoriesCubit, CategoriesView, profileRemoteDataSource, routeName, userEntity, CategorySyncReconciler (+6 more)

### Community 27 - "settings_tile_primitives.dart"
Cohesion: 0.08
Nodes (27): double min,, build, _buildStamp, _buildTitleSubtitle, children, icon, kicker, max (+19 more)

### Community 28 - "editorial_design.dart"
Cohesion: 0.12
Nodes (17): authorName, build, _buildShareAction, createState, EditorialFollowButton, _EditorialFollowButtonState, EditorialIconButton, icon (+9 more)

### Community 29 - "splash_test.dart"
Cohesion: 0.24
Nodes (10): StartupDestination, StartupLogin, StartupMain, StartupOnboarding, package:mind_feed/features/splash/domain/entities/startup_destination.dart, package:mind_feed/features/splash/domain/usecases/check_app_startup_use_case.dart, package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_cubit.dart, package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_state.dart (+2 more)

### Community 30 - "auth_repo.dart"
Cohesion: 0.14
Nodes (12): forgetPassword, login, logout, resendOtp, signup, updatePassword, verifyOtp, verifyRecoveryOtp (+4 more)

### Community 31 - "device_preference_notifier.dart"
Cohesion: 0.13
Nodes (15): copyWith, DevicePreferenceNotifier, DevicePreferences, hashCode, isDarkMode, isSplitLayout, loadDevicePreferences, operator (+7 more)

### Community 32 - "package:mind_feed/config/routes/app_routes.dart"
Cohesion: 0.03
Nodes (53): build, buttonText, CustomButton, height, isLoading, build, _buildRequirementRow, password (+45 more)

### Community 33 - "borders.dart"
Cohesion: 0.12
Nodes (15): card, circular, control, l, m, _main, s, xl (+7 more)

### Community 34 - "theme_config.dart"
Cohesion: 0.13
Nodes (14): app_theme_data.dart, bool?, DynamicSchemeVariant, dark, dynamicSchemeVariant, isAmoledSelected, light, platform (+6 more)

### Community 35 - "article_reader_cubit_test.dart"
Cohesion: 0.04
Nodes (46): String? content,
  int, articleDetailsEntity, clearAllDownloadedArticles, clearDownloadedArticles, createSampleItem, cubit, deleteArticle, deleteDownloadedArticle (+38 more)

### Community 36 - "MindFeed Editorial UI Specification & Architecture"
Cohesion: 0.13
Nodes (14): 1. Visual Design Language (`lib/core/design/editorial_design.dart`), 2. Reusable Modular Components, 3. Screen Implementations, 4. Documentation & Verification Assets, 5. Automated Tests, Card Component (`lib/core/design/editorial_card.dart`), Data Models & Repository (`lib/core/design/editorial_models.dart`, `editorial_mock_data.dart`), Floating Editorial Navigation (`lib/features/main/presentation/widgets/main_navigation_bar.dart`) (+6 more)

### Community 37 - "search_cubit_test.dart"
Cohesion: 0.06
Nodes (35): package:mind_feed/features/home/domain/usecases/get_articles_by_category_use_case.dart, package:mind_feed/features/home/domain/usecases/search_articles_use_case.dart, clearDownloadedArticles, createCubit, deleteArticle, fakeRepo, getArticleById, getArticlesByAuthor (+27 more)

### Community 38 - "main.dart"
Cohesion: 0.17
Nodes (11): globalDevicePreferenceNotifier, init, initFlutter, initialize, loadDevicePreferences, main, package:flutter/services.dart, package:hive_flutter/adapters.dart (+3 more)

### Community 39 - "settings_view_body.dart"
Cohesion: 0.07
Nodes (27): ProfileRepoImpl, ProfileRepository, call, CheckUserHasCategoriesUseCase, profileRepository, _avatarUrl, _breakingAlerts, build (+19 more)

### Community 40 - "Mind Feed"
Cohesion: 0.14
Nodes (13): Architecture, Building APK, Features, Getting Started, Installation, Key Dependencies, License, Mind Feed (+5 more)

### Community 41 - "article_entity.dart"
Cohesion: 0.06
Nodes (35): authorAvatar, authorId, authorName, authorRole, badge, badgeColor, cardColor, categoryId (+27 more)

### Community 42 - "sign_up_form_body.dart"
Cohesion: 0.17
Nodes (11): _autovalidateMode, _confirmPasswordController, createState, dispose, _emailController, formKey, initState, _passwordController (+3 more)

### Community 43 - "onboarding_view_body.dart"
Cohesion: 0.17
Nodes (12): build, createState, _currentPage, dispose, initState, OnboardingViewBody, _OnboardingViewBodyState, _pageController (+4 more)

### Community 44 - "email_confirmation_and_auth_flow_test.dart"
Cohesion: 0.09
Nodes (21): FakeNetworkInfo, HttpOverrides, async, authRepo, connected, createHttpClient, fakeApiSource, fakeUserCache (+13 more)

### Community 45 - "custom_app_bar.dart"
Cohesion: 0.29
Nodes (6): AdvancedDrawerValue, build, CustomAppBar, _handleMenuButtonPressed, title, package:mind_feed/features/home/presentation/views/home_view.dart

### Community 46 - "send_code_view_body.dart"
Cohesion: 0.15
Nodes (12): _autovalidateMode, build, _buildEmailField, _buildHeader, _buildInstructions, createState, dispose, _email (+4 more)

### Community 47 - "duplicate_signup_test.dart"
Cohesion: 0.13
Nodes (16): call, repo, SignupUseCase, build, routeName, signupCubit, SignUpView, package:mind_feed/core/params/signup_params.dart (+8 more)

### Community 48 - "constants.dart"
Cohesion: 0.13
Nodes (14): AppConstants, appName, authConfirmRedirectUrl, compact, hasCompletedCategoriesKey, isOnboardingSeenKey, page, roomy (+6 more)

### Community 49 - "categories_cubit.dart"
Cohesion: 0.18
Nodes (17): CategoriesFailure, CategoriesInitial, CategoriesLoading, CategoriesSelectionChanged, CategoriesState, CategoriesSuccess, errorMessage, isPendingSync (+9 more)

### Community 50 - "StatelessWidget"
Cohesion: 0.05
Nodes (49): Color, build, DraftsEmptyView, DraftsErrorView, message, onRetry, onWriteNew, actionText (+41 more)

### Community 51 - "custom_drawer.dart"
Cohesion: 0.18
Nodes (10): build, CustomDrawer, routeName, build, package:mind_feed/features/collections/presentation/views/downloaded_articles_view.dart, package:mind_feed/features/settings/presentation/views/settings_view.dart, AppRoutes.articlesSaved, AppRoutes.downloadedArticles (+2 more)

### Community 52 - "Fake"
Cohesion: 0.10
Nodes (24): Fake, _client, getCategories, getFavoriteCategories, getProfile, ProfileRemoteDataSource, ProfileRemoteDataSourceImpl, saveFavoriteCategoriesToProfile (+16 more)

### Community 53 - "login_category_check_test.dart"
Cohesion: 0.11
Nodes (17): build, loginCubit, LoginView, routeName, package:mind_feed/features/auth/domain/usecases/login_use_case.dart, package:mind_feed/features/auth/presentation/widgets/login_view_body.dart, package:mind_feed/features/profile/domain/usecases/check_user_has_categories_use_case.dart, fakeToken (+9 more)

### Community 54 - "NetworkInfo"
Cohesion: 0.20
Nodes (10): Connectivity, Future, connectivity, isConnected, NetworkInfo, NetworkInfoImpl, package:connectivity_plus/connectivity_plus.dart, FakeNetworkInfo (+2 more)

### Community 55 - "State"
Cohesion: 0.17
Nodes (16): ChangePasswordForm, _ChangePasswordFormState, LoginForm, _LoginFormState, SendCodeViewBody, _SendCodeViewBodyState, SignUpFormBody, _SignUpFormBodyState (+8 more)

### Community 56 - "editorial_saved_stack.dart"
Cohesion: 0.17
Nodes (12): build, _buildDismissibleCard, createState, _deleteItem, didUpdateWidget, EditorialSavedStack, _EditorialSavedStackState, initState (+4 more)

### Community 57 - "shared_preferences_singleton.dart"
Cohesion: 0.17
Nodes (11): clear, getBool, getKeys, getString, init, _instance, remove, setBool (+3 more)

### Community 58 - "on_boarding_background.dart"
Cohesion: 0.20
Nodes (8): build, OnBoardingBackground, pageController, build, OnBoardingPageView, pageController, package:mind_feed/features/onboarding/presentation/widgets/page_view_item.dart, PageController

### Community 59 - "main_view.dart"
Cohesion: 0.22
Nodes (8): build, createState, initState, routeName, selectedIndex, package:mind_feed/features/main/presentation/widgets/main_navigation_bar.dart, package:mind_feed/features/profile/data/services/category_sync_reconciler.dart, package:mind_feed/features/search/presentation/views/search_view.dart

### Community 60 - "article_view.dart"
Cohesion: 0.15
Nodes (15): ArticleReaderCubit, ArticleReaderState, ArticleView, _ArticleViewContent, build, cubit, initialItem, item (+7 more)

### Community 61 - "MindFeed Editorial UI Transformation Plan"
Cohesion: 0.20
Nodes (9): Architecture decisions, Baseline evidence, Final validation, Goal, MindFeed Editorial UI Transformation Plan, Reference UI description, S1 — Editorial reading shell, S2 — Auth refinement (+1 more)

### Community 62 - "Hermes Review Result: S1-editorial-shell"
Cohesion: 0.20
Nodes (9): Executor evidence, Hermes Review Result: S1-editorial-shell, Independent validation, Recovery decision, Remaining failures or unverified claims, Requirement findings, Scope review, Security and safety (+1 more)

### Community 63 - "add_article_cubit_test.dart"
Cohesion: 0.07
Nodes (27): articles, categories, clearDownloadedArticles, cubit, deleteArticle, getArticleById, getArticlesByAuthor, getArticlesByCategory (+19 more)

### Community 64 - "MindFeed Phase 0 — Repository and Live Database Reconciliation Report"
Cohesion: 0.06
Nodes (33): 1. Executive Summary, 2.1 Git Status & Branching, 2.2 Migration & SQL Script Inventory, 2.3 Dependency Registrations & Service Locator (`setup_service_locator.dart`), 2.4 Existing Codebase Architecture & Data Layer, 2. Repository State and Migration Inventory, 3.1 Live Tables & Schema Summary, 3.2 Exact Table Columns & Constraints (+25 more)

### Community 65 - "@immutable"
Cohesion: 0.29
Nodes (7): @immutable, AppThemeData, ThemeConfig, AppColors, AppTextStyles, AppBorders, SharedPreferencesSingleton

### Community 66 - "app_images.dart"
Cohesion: 0.14
Nodes (13): Assets, assetsImagesBusinessIcon, assetsImagesEducationIcon, assetsImagesJustTest, assetsImagesMindFeedLogo, assetsImagesMITNewsAICoding, assetsImagesOnBoarding1, assetsImagesOnBoarding2 (+5 more)

### Community 67 - "article_reader_markdown_body.dart"
Cohesion: 0.14
Nodes (12): ArticlePreviewView, build, item, ArticleReaderMarkdownBody, ArticleReaderTagsWrap, build, content, excerpt (+4 more)

### Community 68 - "package:flutter/foundation.dart"
Cohesion: 0.25
Nodes (7): Client, http.BaseClient, _inner, send, SupabaseInterceptor, package:flutter/foundation.dart, package:http/http.dart

### Community 69 - "Orchestration State"
Cohesion: 0.25
Nodes (7): Active file leases, Blockers and decisions, Last verified checkpoint, Milestones, Orchestration State, Project, Stage tracker

### Community 70 - "editorial_models.dart"
Cohesion: 0.08
Nodes (24): authorAvatar, authorId, authorName, authorRole, badge, badgeColor, categoryId, categorySlug (+16 more)

### Community 71 - "add_article.dart"
Cohesion: 0.06
Nodes (44): AddArticleCubit, AddArticleView, _AddArticleViewState, build, _contentController, _coverUrlController, createState, dispose (+36 more)

### Community 72 - "signup_params.dart"
Cohesion: 0.25
Nodes (7): displayName, email, password, SignupParams, toJson, toSignUpJson, toUpdateDisplayNameJson

### Community 73 - "search_cubit.dart"
Cohesion: 0.06
Nodes (34): message, props, query, results, CategoryEntity? get, _activeRequestId, _applyFiltersAndEmit, close (+26 more)

### Community 74 - "string_extension.dart"
Cohesion: 0.22
Nodes (8): capitalize, reversed, StringExtension, toDateTime, toDouble, toInt, toNum, String get

### Community 75 - "profile_articles_state.dart"
Cohesion: 0.22
Nodes (12): int get, articles, draftCount, message, ProfileArticlesEmpty, ProfileArticlesError, ProfileArticlesInitial, ProfileArticlesLoaded (+4 more)

### Community 76 - "article_data_and_domain_test.dart"
Cohesion: 0.07
Nodes (27): package:mind_feed/features/home/data/repos/articles_repo_impl.dart, articles, async, categories, connected, deleteArticle, getArticleById, getArticlesByAuthor (+19 more)

### Community 77 - "Design Context"
Cohesion: 0.29
Nodes (6): Aesthetic Direction, Brand Personality, Design Context, Design Principles, Quality Bar, Users

### Community 78 - "editorial_stack_test.dart"
Cohesion: 0.33
Nodes (5): package:mind_feed/core/design/editorial_card_stack.dart, package:mind_feed/core/design/editorial_saved_stack.dart, harness, main, testItems

### Community 79 - "package:mind_feed/core/design/editorial_models.dart"
Cohesion: 0.14
Nodes (13): _authorStories, build, createState, initState, _loadAuthorStories, routeName, package:mind_feed/core/design/editorial_models.dart, package:mind_feed/features/author/presentation/views/author_personal_info.dart (+5 more)

### Community 80 - "check_code_controller.dart"
Cohesion: 0.08
Nodes (24): BuildContext, _authSubscription, autovalidateMode, codeController, context, _cooldownTimer, dispose, _disposed (+16 more)

### Community 81 - "Project Context: Mind Feed"
Cohesion: 0.33
Nodes (5): 1. Overview, 2. Architecture & Directory Structure, 3. Technology Stack & Key Libraries, 4. Recent Project Changes, Project Context: Mind Feed

### Community 82 - "offline_articles_and_logout_test.dart"
Cohesion: 0.10
Nodes (20): GoTrueClient, GoTrueClient get, package:mind_feed/features/auth/data/repos/auth_repo_impl.dart, async, auth, authClient, clearAllCalled, clearAllDownloadedArticles (+12 more)

### Community 83 - "add_article_cubit.dart"
Cohesion: 0.08
Nodes (28): ../controllers/add_article_cubit_test.dart, CurrentUserSnapshot? get, ImageDimensionResolver, _currentUser, dimensionResolver, getCategoriesUseCase, getFixedTagsUseCase, initialize (+20 more)

### Community 84 - "package:mind_feed/core/constants/app_colors.dart"
Cohesion: 0.06
Nodes (26): ArticleEditWarningBanner, build, message, ArticlePreviewHeader, build, _buildAuthorRow, _buildCoverImage, _buildTagsWrap (+18 more)

### Community 85 - "check_code_view_body.dart"
Cohesion: 0.14
Nodes (14): AutovalidateMode, CheckCodeController, build, CheckCodeViewBody, _CheckCodeViewBodyState, _controller, createState, dispose (+6 more)

### Community 86 - "Exception"
Cohesion: 0.60
Nodes (4): Exception?, CacheException, NoInternetException, ServerException

### Community 87 - "login_params.dart"
Cohesion: 0.40
Nodes (4): email, LoginParams, password, toJson

### Community 88 - "downloaded_article_entity.dart"
Cohesion: 0.09
Nodes (21): DateTime, authorAvatar, authorName, authorRole, categoryId, categorySlug, content, copyWith (+13 more)

### Community 90 - "List"
Cohesion: 0.14
Nodes (13): TagModel, description, id, name, props, slug, id, name (+5 more)

### Community 92 - "3. Monolithic Files Exceeding 250 Lines"
Cohesion: 0.08
Nodes (24): 1. Executive Summary, 2.1 Transport Leaks in Domain Layer, 2.2 Shallow Modules (1-Line Use Case Indirections), 2.3 Dead Injections & Misleading Seams, 2.4 False Semantics in Local Cache DataSource, 2.5 Global Mutable State Leaking Cross-Feature, 2.6 Dual Conflicting Cache Implementations, 2. Architectural Seams & Layering Violations (+16 more)

### Community 93 - "articles_remote_data_source.dart"
Cohesion: 0.08
Nodes (23): _client, deleteArticle, getArticleById, getArticlesByAuthor, getArticlesByCategory, getCategories, getFixedTags, getHomeFeed (+15 more)

### Community 94 - "articles_repo_impl.dart"
Cohesion: 0.09
Nodes (22): clearDownloadedArticles, deleteArticle, getArticleById, getArticlesByAuthor, getArticlesByCategory, getCategories, getFixedTags, getHomeFeed (+14 more)

### Community 95 - "package:mind_feed/features/auth/domain/entities/user_entity.dart"
Cohesion: 0.09
Nodes (21): @HiveType, box, clearData, containsKey, getData, getDataFromHive, getDataString, kBoxName (+13 more)

### Community 96 - "articles_repo.dart"
Cohesion: 0.10
Nodes (19): clearDownloadedArticles, deleteArticle, getArticleById, getArticlesByAuthor, getArticlesByCategory, getCategories, getFixedTags, getHomeFeed (+11 more)

### Community 97 - "2. Technical Implementation Boundaries"
Cohesion: 0.11
Nodes (17): 1. Critical Schema & Architectural Reconciliations, 2.1 Feed Ranking & Category Prioritization, 2.2 Content & Image Validation, 2.3 Search, Filtering & Pagination, 2.4 Star & Bookmark Separation, 2.5 Offline Text-Only Storage (BR-04, BR-06), 2.6 Immutability & Deletion Retention, 2. Technical Implementation Boundaries (+9 more)

### Community 98 - "auth_api_source.dart"
Cohesion: 0.12
Nodes (16): authConfirmRedirectUrl, _client, currentUser, login, onAuthStateChange, resendOtp, resetPassword, signInWithGoogle (+8 more)

### Community 99 - "check_code_actions_section.dart"
Cohesion: 0.17
Nodes (11): build, CheckCodeActionsSection, CheckCodeHeader, email, errorMessageListenable, isLoadingListenable, onBackPressed, onResend (+3 more)

### Community 100 - "home_feed_cubit_test.dart"
Cohesion: 0.11
Nodes (17): _FakeProfileRepo, call, GetHomeFeedUseCase, repo, allCategories, articles, failureMessage, favoriteCategories (+9 more)

### Community 101 - "settings_cubit.dart"
Cohesion: 0.21
Nodes (12): cachedMegabytes, copyWith, dataPreservation, SettingsInitial, SettingsLoaded, SettingsState, wifiOnly, clearCache (+4 more)

### Community 102 - "article_model.dart"
Cohesion: 0.29
Nodes (6): copyWith, fromEntity, fromJson, _parseDateTime, _parseTags, toJson

### Community 103 - "String?"
Cohesion: 0.14
Nodes (12): accessToken, AuthResultEntity, email, hasActiveSession, props, userId, copyWith, email (+4 more)

### Community 104 - "article_validator.dart"
Cohesion: 0.08
Nodes (25): bool get, ArticleValidator, categoryError, computeReadingTime, contentError, copyWith, countWords, coverImageUrlError (+17 more)

### Community 105 - "MindFeed Phase 1 — Database Baseline & Migration Reconciliation Verification Report"
Cohesion: 0.17
Nodes (11): 1. Executive Summary, 2.1 Baseline Migration: `supabase/migrations/20261015000000_baseline_schema.sql`, 2.2 Catalog Seed Migration: `supabase/migrations/20261015000001_seed_catalog.sql`, 2.3 Supabase Configuration & Supplemental Seeds, 2. Deliverables Inventory in Version Control, 3. Local Clean Database Verification Results, 4.1 Migration History Tracking, 4.2 Live Data Preservation Audit (+3 more)

### Community 106 - "MindFeed Phase 1 — Database Baseline and Migration Reconciliation Report"
Cohesion: 0.18
Nodes (10): 1. Executive Summary, 2.1 Baseline Migration, 2.2 Seed Migrations & Local Seed Files, 2.3 Production Editorial Articles Backup, 2. Deliverables Inventory, 3. Live Database Verification and Integrity Evidence, 4. Migration History Reconciliation Evidence, 5. Phase 1 Completion & Next Steps (+2 more)

### Community 107 - "fake_articles_repository.dart"
Cohesion: 0.08
Nodes (23): authorArticles, clearDownloadedArticles, deleteArticle, failureMessage, getArticleById, getArticlesByAuthor, getArticlesByCategory, getCategories (+15 more)

### Community 108 - "search_filter_chips_bar.dart"
Cohesion: 0.12
Nodes (15): CategoryModel, fromEntity, fromJson, toJson, CategoryEntity, build, categories, onCategorySelected (+7 more)

### Community 109 - "personal_infromation.dart"
Cohesion: 0.17
Nodes (12): _articlesCount, _avatarUrl, build, createState, _displayName, _followingCount, initState, _loadProfileData (+4 more)

### Community 110 - "change_password_form.dart"
Cohesion: 0.14
Nodes (13): GlobalKey, _autovalidateMode, build, _buildConfirmPasswordField, _buildNewPasswordField, _buildRequirements, _confirmPassword, createState (+5 more)

### Community 111 - "custom_loading_indecator.dart"
Cohesion: 0.16
Nodes (13): dart:math, build, color, _controller, createState, CustomLoadingIndecator, CustomLoadingIndicator, _CustomLoadingIndicatorState (+5 more)

### Community 112 - "failures.dart"
Cohesion: 0.43
Nodes (6): CacheFailure, Failure, message, props, ServerFailure, ValidationFailure

### Community 113 - "user_cache_source.dart"
Cohesion: 0.18
Nodes (10): dart:convert, CacheHelper, cacheHelper, getUser, key, UserCacheDataSource, package:mind_feed/core/database/cache/cache_helper.dart, package:mind_feed/core/errors/exceptions.dart (+2 more)

### Community 114 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.18
Nodes (9): build, CategoriesViewBody, userEntity, build, _buildThemeCard, package:flutter_bloc/flutter_bloc.dart, package:mind_feed/core/widgets/custom_button.dart, package:mind_feed/features/auth/presentation/controllers/categories_cubit/categories_cubit.dart (+1 more)

### Community 115 - "widget_test.dart"
Cohesion: 0.08
Nodes (24): package:mind_feed/features/main/presentation/views/main_view.dart, package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart, clearDownloadedArticles, deleteArticle, editorialHarness, getArticleById, getArticlesByAuthor, getArticlesByCategory (+16 more)

### Community 116 - "home_masthead_header.dart"
Cohesion: 0.14
Nodes (12): build, HomeMastheadHeader, HomeTopicTabsBar, onTopicSelected, selectedTopic, topics, build, description (+4 more)

### Community 117 - "article_reader_deps.dart"
Cohesion: 0.08
Nodes (26): article_reader_deps.dart, article_reader_state.dart, _currentUserId, _deps, downloadArticle, _getUserId, initArticle, toggleBookmark (+18 more)

### Community 118 - "package:mind_feed/core/utls/setup_service_locator.dart"
Cohesion: 0.10
Nodes (18): articlesRepository, deleteArticleUseCase, deleteDraft, loadDrafts, DeleteArticleUseCase, _articles, _articlesRepo, _configuredUserId (+10 more)

### Community 119 - "main_navigation_bar.dart"
Cohesion: 0.08
Nodes (21): IconData, categories, CategoryItem, icon, name, build, category, CategoryCard (+13 more)

### Community 120 - "add_article_state.dart"
Cohesion: 0.06
Nodes (32): Equatable, ArticleFormErrors, AddArticleState, availableTags, categories, content, contentWordCount, copyWith (+24 more)

### Community 121 - "login_form.dart"
Cohesion: 0.15
Nodes (12): FormState, _autovalidateMode, build, createState, dispose, _emailController, formKey, initState (+4 more)

### Community 122 - "check_code_args.dart"
Cohesion: 0.50
Nodes (3): CheckCodeArgs, email, isPasswordReset

### Community 123 - "categories_view_test.dart"
Cohesion: 0.17
Nodes (11): Map, package:mind_feed/features/auth/presentation/views/categories_view.dart, allCategories, getCategories, getFavoriteCategories, main, saveFavoriteCategoriesToProfile, setFavoriteCategories (+3 more)

### Community 124 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.17
Nodes (10): fake_articles_repository.dart, package:flutter_test/flutter_test.dart, package:flutter/widgets.dart, main, cubit, deleteUseCase, fakeRepo, main (+2 more)

### Community 125 - "forget_password_flow_test.dart"
Cohesion: 0.10
Nodes (19): _FakeAuthRepository, package:mind_feed/features/auth/presentation/views/change_password_view.dart, package:mind_feed/features/auth/presentation/views/send_code_view.dart, fakeRepo, forgetPassword, forgetPasswordResult, forgetPasswordUseCase, lastForgetPasswordEmail (+11 more)

### Community 127 - "Cubit"
Cohesion: 0.16
Nodes (14): Cubit, HomeFeedCubit, build, build, cubit, HomeViewBody, _HomeViewBodyContent, build (+6 more)

### Community 128 - "package:mind_feed/core/networking/api_result.dart"
Cohesion: 0.06
Nodes (40): ArticlesRepositoryImpl, ArticlesRepository, call, repo, call, GetArticleDetailsUseCase, repo, call (+32 more)

### Community 130 - "DraftsCubit"
Cohesion: 0.09
Nodes (33): add_article_cubit_test.dart, FakeArticlesRepository, DraftsCubit, drafts, DraftsEmpty, DraftsError, DraftsInitial, DraftsLoaded (+25 more)

### Community 131 - "auth_forms_test.dart"
Cohesion: 0.13
Nodes (13): build, SignUpForm, package:mind_feed/features/auth/presentation/widgets/password_text_field.dart, package:mind_feed/features/auth/presentation/widgets/sign_up_form_body.dart, forgetPassword, login, logout, main (+5 more)

### Community 132 - "profile_repo.dart"
Cohesion: 0.25
Nodes (7): getCategories, getFavoriteCategories, getProfile, reconcilePendingCategorySync, saveLocalCategories, syncFavoriteCategories, updateProfile

### Community 133 - "editorial_card.dart"
Cohesion: 0.08
Nodes (22): build, EditorialCard, item, onLike, onOpen, onSave, onShare, showActions (+14 more)

### Community 134 - "article_reader_header.dart"
Cohesion: 0.07
Nodes (25): build, CustomTextField, hintText, keyboardType, obscureText, onChanged, prefixIcon, suffixIcon (+17 more)

### Community 135 - "downloads_cubit_test.dart"
Cohesion: 0.11
Nodes (18): FakeArticlesLocalDataSource, required String title,
  String, author, clearAllDownloadedArticles, createTestArticle, cubit, deleteDownloadedArticle, deleteUseCase (+10 more)

### Community 136 - "downloaded_articles_view.dart"
Cohesion: 0.15
Nodes (15): DownloadsCubit, build, cubit, DownloadedArticlesView, routeName, build, DownloadedArticlesViewBody, package:mind_feed/core/widgets/custom_app_bar.dart (+7 more)

### Community 137 - "DownloadedArticleEntity"
Cohesion: 0.67
Nodes (3): DownloadedArticleEntity, DownloadedArticleEntityAdapter, TypeAdapter

### Community 138 - "check_app_startup_use_case.dart"
Cohesion: 0.20
Nodes (9): ../entities/startup_destination.dart, AuthApiSource, _authApiSource, call, _cleanupIncompleteSession, _hasActiveSession, _hasCompletedCategories, package:mind_feed/features/auth/data/datasources/auth_api_source.dart (+1 more)

### Community 139 - "forget_password_cubit.dart"
Cohesion: 0.29
Nodes (11): email, errorMessage, ForgetPasswordFailure, ForgetPasswordInitial, ForgetPasswordLoading, ForgetPasswordState, ForgetPasswordSuccess, ForgetPasswordCubit (+3 more)

### Community 140 - "downloads_cubit.dart"
Cohesion: 0.14
Nodes (13): downloads_state.dart, _applyFilter, deleteDownload, _deleteDownloadedArticleUseCase, filterArticles, _getDownloadedArticlesUseCase, loadDownloads, _localDataSource (+5 more)

### Community 141 - "password_text_field.dart"
Cohesion: 0.18
Nodes (11): FocusNode, build, controller, createState, dispose, hintText, _isObscured, onChanged (+3 more)

### Community 142 - "article_reader_state.dart"
Cohesion: 0.17
Nodes (11): ArticleReaderStatus, copyWith, errorMessage, isDownloaded, isSaved, isStarred, item, props (+3 more)

### Community 143 - "datasources/articles_local_data_source.dart"
Cohesion: 0.18
Nodes (10): Box, _box, boxName, clearAllDownloadedArticles, deleteDownloadedArticle, getDownloadedArticleById, getDownloadedArticles, _openBox (+2 more)

### Community 144 - "change_password_cubit.dart"
Cohesion: 0.26
Nodes (12): ChangePasswordFailure, ChangePasswordInitial, ChangePasswordLoading, ChangePasswordState, ChangePasswordSuccess, errorMessage, ChangePasswordCubit, updatePassword (+4 more)

### Community 145 - "current_user_session.dart"
Cohesion: 0.14
Nodes (13): dart:async, avatarUrl, cacheUserCategories, currentUserId, CurrentUserSession, CurrentUserSnapshot, displayName, email (+5 more)

### Community 146 - "downloads_state.dart"
Cohesion: 0.20
Nodes (9): allArticles, copyWith, DownloadsStatus, errorMessage, feedbackMessage, filteredArticles, props, searchQuery (+1 more)

### Community 147 - "settings_reading_section.dart"
Cohesion: 0.07
Nodes (26): build, controller, CustomSearchBar, hintText, onChanged, semanticLabel, trailingSearchIcon, build (+18 more)

### Community 148 - "package:mind_feed/core/constants/constants.dart"
Cohesion: 0.22
Nodes (8): build, currentPage, NextButton, pageController, build, SkipButton, package:mind_feed/core/constants/constants.dart, package:mind_feed/core/services/shared_preferences_singleton.dart

### Community 149 - "add_to_favorite_article_card.dart"
Cohesion: 0.40
Nodes (5): AddToFavoriteArticleCard, _AddToFavoriteArticleCardState, build, createState, isFav

### Community 150 - "search_view.dart"
Cohesion: 0.19
Nodes (13): SearchEmpty, SearchError, SearchInitial, SearchLoading, SearchState, SearchCubit, build, routeName (+5 more)

### Community 151 - "splash_logo_widget.dart"
Cohesion: 0.12
Nodes (18): Animation, AnimationController, _breathingAnimation, _breathingController, build, createState, dispose, HomeBreathingBackground (+10 more)

### Community 152 - "articles_saved.dart"
Cohesion: 0.18
Nodes (11): ArticlesSaved, _ArticlesSavedContent, _ArticlesSavedContentState, build, createState, dispose, initState, routeName (+3 more)

### Community 153 - "ArticlesLocalDataSource"
Cohesion: 0.12
Nodes (17): ArticlesLocalDataSourceImpl, ArticlesLocalDataSource, call, DeleteDownloadedArticleUseCase, localDataSource, call, DownloadArticleTextUseCase, localDataSource (+9 more)

### Community 154 - "splash_view.dart"
Cohesion: 0.22
Nodes (8): ../controllers/splash_cubit/splash_cubit.dart, ../controllers/splash_cubit/splash_state.dart, build, child, routeName, SplashListener, SplashView, ../widgets/splash_view_body.dart

### Community 155 - "ProfileArticlesCubit"
Cohesion: 0.13
Nodes (20): ProfileArticlesCubit, build, articlesCount, avatarUrl, build, _buildStatItem, displayName, followingCount (+12 more)

### Community 156 - "list_saved_articles.dart"
Cohesion: 0.40
Nodes (4): build, ListSavedArticles, routeName, package:mind_feed/features/collections/presentation/views/articles_saved.dart

### Community 157 - "splash_cubit.dart"
Cohesion: 0.22
Nodes (8): ../../../domain/entities/startup_destination.dart, ../../../domain/usecases/check_app_startup_use_case.dart, Duration, CheckAppStartupUseCase, _checkAppStartupUseCase, initApp, _minDisplayDuration, splash_state.dart

### Community 158 - "api_result.dart"
Cohesion: 0.33
Nodes (8): ../errors/failures.dart, ApiResult, data, failure, FailureResult, Success, R, T

### Community 159 - "home_feed_state.dart"
Cohesion: 0.22
Nodes (8): allArticles, copyWith, errorMessage, HomeFeedStatus, props, selectedTopic, status, topics

### Community 160 - "settings_dialogs.dart"
Cohesion: 0.22
Nodes (8): context, options, showDialog, showDigestPickerSheet, showEditProfileSheet, showModalBottomSheet, showPrivacyManifestDialog, showSignOutDialog

### Community 161 - "home_view.dart"
Cohesion: 0.25
Nodes (7): AdvancedDrawerController, advancedDrawerController, build, HomeView, routeName, package:flutter_advanced_drawer/flutter_advanced_drawer.dart, package:mind_feed/features/home/presentation/widgets/home_view_body.dart

### Community 162 - "article_field_helpers.dart"
Cohesion: 0.25
Nodes (7): articleInputDecoration, ArticleSectionHeader, build, counter, isCounterError, isCounterSuccess, title

### Community 163 - "change_password_view.dart"
Cohesion: 0.29
Nodes (6): build, cubit, email, routeName, package:mind_feed/features/auth/presentation/controllers/change_password_cubit/change_password_cubit.dart, package:mind_feed/features/auth/presentation/widgets/change_password_view_body.dart

### Community 164 - "downloaded_article_card_tile.dart"
Cohesion: 0.25
Nodes (7): article, build, DownloadedArticleCardTile, _formatDate, isDark, onDelete, MaterialPageRoute

### Community 165 - "package:mind_feed/core/errors/failures.dart"
Cohesion: 0.22
Nodes (7): call, PublishArticleUseCase, repo, call, repo, UpdateArticleUseCase, package:mind_feed/core/errors/failures.dart

### Community 166 - "user_articles_widget_test.dart"
Cohesion: 0.10
Nodes (17): build, ProfileView, routeName, build, ProfileViewBody, package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_cubit.dart, package:mind_feed/features/profile/presentation/widget/personal_infromation.dart, package:mind_feed/features/profile/presentation/widget/profile_app_bar.dart (+9 more)

### Community 167 - "check_code_view.dart"
Cohesion: 0.29
Nodes (6): build, CheckCodeView, email, isPasswordReset, routeName, package:mind_feed/features/auth/presentation/widgets/check_code_view_body.dart

### Community 168 - "send_code_view.dart"
Cohesion: 0.29
Nodes (6): build, cubit, routeName, SendCodeView, package:mind_feed/features/auth/presentation/controllers/forget_password_cubit/forget_password_cubit.dart, package:mind_feed/features/auth/presentation/widgets/send_code_view_body.dart

### Community 169 - "search_filter_helper_test.dart"
Cohesion: 0.33
Nodes (5): SearchLoaded, package:mind_feed/features/search/domain/helpers/search_filter_helper.dart, item1, item2, main

### Community 170 - "static const String"
Cohesion: 0.33
Nodes (5): addArticle, AddArticleRoutes, articlePreview, drafts, static const String

### Community 171 - "save_favorite_categories_use_case.dart"
Cohesion: 0.22
Nodes (8): call, CategorySaveOutcome, errorMessage, isLocalSaved, isPendingSync, isRemoteSynced, repository, SaveFavoriteCategoriesUseCase

### Community 172 - "SplashCubit"
Cohesion: 0.62
Nodes (6): SplashCubit, SplashInitial, SplashNavigateToLogin, SplashNavigateToMain, SplashNavigateToOnboarding, SplashState

### Community 173 - "main_app.dart"
Cohesion: 0.29
Nodes (6): build, MyApp, package:mind_feed/config/extensions/string_extension.dart, package:mind_feed/config/themes/theme_config.dart, package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart, package:mind_feed/l10n/generated/app_localizations.dart

### Community 174 - "package:mind_feed/features/home/domain/entities/tag_entity.dart"
Cohesion: 0.20
Nodes (10): fromEntity, fromJson, toJson, _, copyStateWithFilters, filterByTags, mapFailureMessage, SearchFilterHelper (+2 more)

### Community 175 - "repos/articles_local_data_source.dart"
Cohesion: 0.33
Nodes (5): clearAllDownloadedArticles, deleteDownloadedArticle, getDownloadedArticleById, getDownloadedArticles, saveDownloadedArticle

### Community 177 - "ArticlesRemoteDataSource"
Cohesion: 0.67
Nodes (3): ArticlesRemoteDataSource, ArticlesRemoteDataSourceImpl, FakeArticlesRemoteDataSource

## Knowledge Gaps
- **2065 isolated node(s):** `capitalize`, `reversed`, `toInt`, `toDouble`, `toNum` (+2060 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 2275 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `UserEntity` connect `package:mind_feed/features/auth/domain/entities/user_entity.dart` to `category_onboarding_clean_architecture_test.dart`, `profile_repo_impl.dart`, `String?`, `settings_view_body.dart`, `main.dart`, `category_sync_hardening_test.dart`, `signup_cubit.dart`, `current_user_session.dart`, `auth_repo_impl.dart`, `package:flutter_bloc/flutter_bloc.dart`, `offline_articles_and_logout_test.dart`, `login_cubit.dart`, `categories_view.dart`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Why does `ArticlesRepository` connect `package:mind_feed/core/networking/api_result.dart` to `articles_repo.dart`, `home_feed_cubit_test.dart`, `setup_service_locator.dart`, `package:mind_feed/core/errors/failures.dart`, `settings_view_body.dart`, `personal_infromation.dart`, `Fake`, `article_reader_deps.dart`, `package:mind_feed/core/utls/setup_service_locator.dart`?**
  _High betweenness centrality (0.005) - this node is a cross-community bridge._
- **Why does `ArticlesLocalDataSource` connect `ArticlesLocalDataSource` to `setup_service_locator.dart`, `settings_view_body.dart`, `downloads_cubit.dart`, `repos/articles_local_data_source.dart`, `article_reader_deps.dart`, `articles_repo_impl.dart`?**
  _High betweenness centrality (0.005) - this node is a cross-community bridge._
- **What connects `capitalize`, `reversed`, `toInt` to the rest of the system?**
  _2065 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.01652892561983471 - nodes in this community are weakly interconnected._
- **Should `app_icons.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.020833333333333332 - nodes in this community are weakly interconnected._
- **Should `category_onboarding_clean_architecture_test.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._