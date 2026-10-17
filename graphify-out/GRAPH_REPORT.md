# Graph Report - MindFeed-main  (2026-10-17)

## Corpus Check
- 325 files · ~263,687 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 3419 nodes · 5338 edges · 181 communities (177 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `067f37b4`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- app_colors.dart
- app_icons.dart
- category_onboarding_clean_architecture_test.dart
- app_text_styles.dart
- NetworkInfo
- editorial_card_stack.dart
- package:mind_feed/features/auth/domain/entities/user_entity.dart
- settings_reading_section.dart
- app_routes.dart
- 2. Why Certain Decisions Were Made (Architectural & Mechanical Rationale)
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
- article_reader_action_bar.dart
- package:mind_feed/core/constants/app_text_styles.dart
- add_article_cubit_test.dart
- Task Packet: S1-editorial-shell
- Task Packet: S2-auth-refinement
- profile_repo_impl.dart
- settings_tile_primitives.dart
- editorial_design.dart
- splash_test.dart
- auth_repo.dart
- device_preference_notifier.dart
- article_card.dart
- borders.dart
- article_reader_cubit.dart
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
- downloads_cubit_test.dart
- send_code_view_body.dart
- duplicate_signup_test.dart
- constants.dart
- categories_cubit.dart
- StatelessWidget
- custom_drawer.dart
- Fake
- login_category_check_test.dart
- package:mind_feed/core/constants/app_colors.dart
- main_navigation_bar.dart
- editorial_saved_stack.dart
- shared_preferences_singleton.dart
- add_article.dart
- main_view.dart
- article_view.dart
- MindFeed Editorial UI Transformation Plan
- Hermes Review Result: S1-editorial-shell
- categories_view.dart
- MindFeed Phase 0 — Repository and Live Database Reconciliation Report
- @immutable
- app_images.dart
- article_reader_markdown_body.dart
- settings_archive_section.dart
- Orchestration State
- editorial_models.dart
- package:flutter_bloc/flutter_bloc.dart
- signup_params.dart
- search_cubit.dart
- home_lead_story_section.dart
- ProfileArticlesCubit
- article_data_and_domain_test.dart
- Design Context
- settings_menu.dart
- package:mind_feed/core/design/editorial_models.dart
- check_code_controller.dart
- Project Context: Mind Feed
- offline_articles_and_logout_test.dart
- setup_service_locator.dart
- package:mind_feed/core/constants/app_images.dart
- check_code_view_body.dart
- sign_up_view_body.dart
- login_params.dart
- downloaded_article_entity.dart
- package:equatable/equatable.dart
- cubit.dart
- 3. Monolithic Files Exceeding 250 Lines
- articles_remote_data_source.dart
- articles_repo_impl.dart
- cache_helper.dart
- articles_repo.dart
- 2. Technical Implementation Boundaries
- auth_api_source.dart
- check_app_startup_use_case.dart
- home_feed_cubit_test.dart
- Cubit
- Equatable
- drafts_cubit_test.dart
- article_validator.dart
- MindFeed Phase 1 — Database Baseline & Migration Reconciliation Verification Report
- MindFeed Phase 1 — Database Baseline and Migration Reconciliation Report
- fake_articles_repository.dart
- search_filter_chips_bar.dart
- personal_infromation.dart
- change_password_form.dart
- custom_loading_indecator.dart
- failures.dart
- home_breathing_background.dart
- splash_cubit.dart
- widget_test.dart
- api_result.dart
- article_reader_deps.dart
- profile_articles_cubit.dart
- package:mind_feed/core/constants/app_icons.dart
- add_article_state.dart
- login_form.dart
- check_code_args.dart
- package:flutter_test/flutter_test.dart
- string_extension.dart
- forget_password_flow_test.dart
- home_view_body.dart
- package:mind_feed/features/home/domain/repos/articles_repo.dart
- DraftsCubit
- auth_forms_test.dart
- article_slow_scroll_bar.dart
- package:mind_feed/core/errors/failures.dart
- article_reader_header.dart
- user_cache_source.dart
- downloaded_articles_view_body.dart
- downloaded_articles_view.dart
- UserEntity
- forget_password_cubit.dart
- downloads_cubit.dart
- password_text_field.dart
- article_reader_state.dart
- SplashCubit
- change_password_cubit.dart
- current_user_session.dart
- downloads_state.dart
- custom_text_field.dart
- datasources/articles_local_data_source.dart
- articles_category_view.dart
- search_view.dart
- article_view_widget_test.dart
- articles_saved.dart
- Exception?
- author_rating_and_like_data_test.dart
- profile_avatar_and_stats.dart
- List
- package:supabase_flutter/supabase_flutter.dart
- package:mind_feed/features/home/domain/entities/tag_entity.dart
- home_feed_state.dart
- settings_dialogs.dart
- custom_app_bar.dart
- static const String
- change_password_view.dart
- splash_logo_widget.dart
- package:mind_feed/core/networking/api_result.dart
- user_articles_widget_test.dart
- check_code_view.dart
- send_code_view.dart
- _
- package:flutter/foundation.dart
- article_payload_builder.dart
- article_field_helpers.dart
- downloaded_article_card_tile.dart
- DownloadedArticleEntity
- profile_repo.dart
- categories_view_body.dart
- repos/articles_local_data_source.dart
- package:mind_feed/core/utls/setup_service_locator.dart
- article_view_body.dart
- get_categories_use_case.dart

## God Nodes (most connected - your core abstractions)
1. `ArticlesRepository` - 29 edges
2. `AddArticleCubit` - 24 edges
3. `Continuation Packet: S1-editorial-shell-recovery` - 19 edges
4. `ProfileArticlesCubit` - 18 edges
5. `Task Packet: S1-editorial-shell` - 18 edges
6. `Task Packet: S2-auth-refinement` - 18 edges
7. `AuthRepository` - 17 edges
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

## Communities (181 total, 1 thin omitted)

### Community 0 - "app_colors.dart"
Cohesion: 0.02
Nodes (120): almostBlack, amber, amberDark, amberDarker, black, blue, blueMain, blush (+112 more)

### Community 1 - "app_icons.dart"
Cohesion: 0.02
Nodes (95): add, alternateEmailRounded, AppIcons, arrowBackRounded, arrowForwardIosRounded, artDesign, articleOutlined, boltRounded (+87 more)

### Community 2 - "category_onboarding_clean_architecture_test.dart"
Cohesion: 0.07
Nodes (26): PostgrestException, PostgrestFilterBuilder, categoriesList, clearDownloadedArticles, clearOfflineCalled, FakePostgrestFilterBuilder, from, fromInvoked (+18 more)

### Community 3 - "app_text_styles.dart"
Cohesion: 0.09
Nodes (21): bodyLarge, bodyMedium, bodySmall, displayLarge, displayMedium, displaySmall, headlineLarge, headlineMedium (+13 more)

### Community 4 - "NetworkInfo"
Cohesion: 0.20
Nodes (10): Connectivity, Future, connectivity, isConnected, NetworkInfo, NetworkInfoImpl, package:connectivity_plus/connectivity_plus.dart, FakeNetworkInfo (+2 more)

### Community 5 - "editorial_card_stack.dart"
Cohesion: 0.09
Nodes (22): _animController, build, _buildCard, _buildFeedbackBadge, _cards, createState, didUpdateWidget, dispose (+14 more)

### Community 6 - "package:mind_feed/features/auth/domain/entities/user_entity.dart"
Cohesion: 0.33
Nodes (5): fromEntity, fromJson, toJson, toUserEntity, package:mind_feed/features/auth/domain/entities/user_entity.dart

### Community 7 - "settings_reading_section.dart"
Cohesion: 0.13
Nodes (14): bionicGuide, breakingAlerts, build, fontScale, morningBriefing, onBionicGuideChanged, onBreakingAlertsChanged, onFontScaleChanged (+6 more)

### Community 8 - "app_routes.dart"
Cohesion: 0.05
Nodes (37): addArticle, AppRoutes, article, articlePreview, articlesCategory, articlesSaved, author, categories (+29 more)

### Community 9 - "2. Why Certain Decisions Were Made (Architectural & Mechanical Rationale)"
Cohesion: 0.10
Nodes (19): 1. Executive Summary, 2.1 Why `origin/main` Was Merged Before Feature Orchestration, 2.2 Why the Shared Foundation Was Laid By the Orchestrator First, 2.3 Why `CurrentUserSession` Was Created (`lib/core/services/current_user_session.dart`), 2.4 Why Monolithic Views Were Decomposed (<150 Lines per View), 2.5 Why All Mock Fallbacks (`EditorialMockData`) Were Deleted, 2.6 Why the Supabase Database Functions & Triggers Were Hardened (`SET search_path = ''`), 2. Why Certain Decisions Were Made (Architectural & Mechanical Rationale) (+11 more)

### Community 10 - "app_theme_data.dart"
Cohesion: 0.06
Nodes (30): card, checkbox, chip, dialog, dropdownMenu, filledButton, floatingActionButton, iconButton (+22 more)

### Community 11 - "category_sync_hardening_test.dart"
Cohesion: 0.11
Nodes (17): dart:io, Directory, MockProfileRemoteDataSource, package:mind_feed/features/home/data/datasources/articles_local_data_source.dart, categoriesList, clearAllDownloadedArticles, cleared, getCategories (+9 more)

### Community 12 - "collections_cubit.dart"
Cohesion: 0.16
Nodes (18): CollectionsEmpty, CollectionsError, CollectionsInitial, CollectionsLoaded, CollectionsLoading, CollectionsState, message, props (+10 more)

### Community 13 - "theme_mode_cubit.dart"
Cohesion: 0.44
Nodes (8): ThemeModeDark, ThemeModeInitial, ThemeModeLight, ThemeModeState, ThemeModeSystem, changeThemeMode, getThemeMode, ThemeModeCubit

### Community 14 - "Business Requirements Document (BRD)"
Cohesion: 0.08
Nodes (24): 1.1 Purpose, 1.2 Business Problem Statement, 1.3 Vision & Solution, 1. Executive Summary, 2. Business Objectives & Key Performance Indicators (KPIs), 3.1 Competitive Landscape, 3.2 Target Audience Segments, 3. Market Analysis & Value Proposition (+16 more)

### Community 15 - "home_feed_cubit.dart"
Cohesion: 0.07
Nodes (25): home_feed_state.dart, call, repo, ToggleBookmarkUseCase, _currentUserId, fetchFeed, _getHomeFeedUseCase, _getSavedArticlesUseCase (+17 more)

### Community 16 - "signup_cubit.dart"
Cohesion: 0.21
Nodes (15): email, errorMessage, isUserAlreadyRegistered, SignupFailure, SignupInitial, SignupLoading, SignupRequiresConfirmation, SignupState (+7 more)

### Community 17 - "auth_repo_impl.dart"
Cohesion: 0.13
Nodes (14): authApiSource, cacheHelper, forgetPassword, login, logout, networkInfo, resendOtp, signup (+6 more)

### Community 18 - "package:flutter/material.dart"
Cohesion: 0.06
Nodes (27): customShowSnackBar, duration, ArticleEditWarningBanner, build, message, authBackground, build, ListForSavedArticles (+19 more)

### Community 19 - "Mini-requirements"
Cohesion: 0.09
Nodes (21): 1. Mandatory Authentication & Onboarding, 2. Home Feed & Discovery, 3. Article Reader, Starring & Sharing, 4. Offline Mode (Text-Only), 5. Article Drafting, Preview, Publishing & Lifecycle, 6. Personal Collections & Settings, Acceptance Criteria, Business Rules (+13 more)

### Community 20 - "Continuation Packet: S1-editorial-shell-recovery"
Cohesion: 0.10
Nodes (19): Allowed edit scope, Areas that must not be redesigned, Completed work, Continuation objective, Continuation Packet: S1-editorial-shell-recovery, Current failures, Exact files to inspect, Exact remaining work (+11 more)

### Community 21 - "article_reader_action_bar.dart"
Cohesion: 0.07
Nodes (28): app_theme_data.dart, bool?, DynamicSchemeVariant, int?, dark, dynamicSchemeVariant, isAmoledSelected, light (+20 more)

### Community 22 - "package:mind_feed/core/constants/app_text_styles.dart"
Cohesion: 0.09
Nodes (18): build, CustomSliverAppBarForArticlesSaved, ArticleCardInformation, author, build, date, title, author (+10 more)

### Community 23 - "add_article_cubit_test.dart"
Cohesion: 0.07
Nodes (27): articles, categories, clearDownloadedArticles, cubit, deleteArticle, getArticleById, getArticlesByAuthor, getArticlesByCategory (+19 more)

### Community 24 - "Task Packet: S1-editorial-shell"
Cohesion: 0.11
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 25 - "Task Packet: S2-auth-refinement"
Cohesion: 0.11
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 26 - "profile_repo_impl.dart"
Cohesion: 0.07
Nodes (30): getCategories, getFavoriteCategories, getProfile, _isReconciling, ProfileRepoImpl, reconcilePendingCategorySync, remoteDataSource, saveLocalCategories (+22 more)

### Community 27 - "settings_tile_primitives.dart"
Cohesion: 0.08
Nodes (27): double min,, build, _buildStamp, _buildTitleSubtitle, children, icon, kicker, max (+19 more)

### Community 28 - "editorial_design.dart"
Cohesion: 0.09
Nodes (24): authorName, build, _buildShareAction, createState, EditorialFollowButton, _EditorialFollowButtonState, EditorialIconButton, icon (+16 more)

### Community 29 - "splash_test.dart"
Cohesion: 0.24
Nodes (10): StartupDestination, StartupLogin, StartupMain, StartupOnboarding, package:mind_feed/features/splash/domain/entities/startup_destination.dart, package:mind_feed/features/splash/domain/usecases/check_app_startup_use_case.dart, package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_cubit.dart, package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_state.dart (+2 more)

### Community 30 - "auth_repo.dart"
Cohesion: 0.15
Nodes (12): forgetPassword, login, logout, resendOtp, signup, updatePassword, verifyOtp, verifyRecoveryOtp (+4 more)

### Community 31 - "device_preference_notifier.dart"
Cohesion: 0.12
Nodes (16): int get, copyWith, DevicePreferenceNotifier, DevicePreferences, hashCode, isDarkMode, isSplitLayout, loadDevicePreferences (+8 more)

### Community 32 - "article_card.dart"
Cohesion: 0.09
Nodes (20): build, isleft, ListCard, listCardBody, ArticleCard, author, date, imagePath (+12 more)

### Community 33 - "borders.dart"
Cohesion: 0.12
Nodes (15): card, circular, control, l, m, _main, s, xl (+7 more)

### Community 34 - "article_reader_cubit.dart"
Cohesion: 0.10
Nodes (19): article_reader_deps.dart, article_reader_state.dart, _currentUserId, _deps, downloadArticle, _getUserId, initArticle, rateAuthor (+11 more)

### Community 35 - "article_reader_cubit_test.dart"
Cohesion: 0.03
Nodes (60): String? content,
  int, articleDetailsEntity, authorRatingAvg, authorRatingCount, authorUserStars, clearAllDownloadedArticles, clearDownloadedArticles, createSampleItem (+52 more)

### Community 36 - "MindFeed Editorial UI Specification & Architecture"
Cohesion: 0.13
Nodes (14): 1. Visual Design Language (`lib/core/design/editorial_design.dart`), 2. Reusable Modular Components, 3. Screen Implementations, 4. Documentation & Verification Assets, 5. Automated Tests, Card Component (`lib/core/design/editorial_card.dart`), Data Models & Repository (`lib/core/design/editorial_models.dart`, `editorial_mock_data.dart`), Floating Editorial Navigation (`lib/features/main/presentation/widgets/main_navigation_bar.dart`) (+6 more)

### Community 37 - "search_cubit_test.dart"
Cohesion: 0.06
Nodes (35): package:mind_feed/features/home/domain/usecases/get_articles_by_category_use_case.dart, package:mind_feed/features/home/domain/usecases/search_articles_use_case.dart, clearDownloadedArticles, createCubit, deleteArticle, fakeRepo, getArticleById, getArticlesByAuthor (+27 more)

### Community 38 - "main.dart"
Cohesion: 0.18
Nodes (10): globalDevicePreferenceNotifier, init, initFlutter, initialize, loadDevicePreferences, main, package:flutter/services.dart, package:mind_feed/core/networking/supabase_interceptor.dart (+2 more)

### Community 39 - "settings_view_body.dart"
Cohesion: 0.10
Nodes (21): _avatarUrl, _breakingAlerts, build, _cachedMegabytes, createState, _currentUserEntity, _displayName, _handleClearCache (+13 more)

### Community 40 - "Mind Feed"
Cohesion: 0.14
Nodes (13): Architecture, Building APK, Features, Getting Started, Installation, Key Dependencies, License, Mind Feed (+5 more)

### Community 41 - "article_entity.dart"
Cohesion: 0.05
Nodes (38): authorAvatar, authorId, authorName, authorRatingAvg, authorRatingCount, authorRole, badge, badgeColor (+30 more)

### Community 42 - "sign_up_form_body.dart"
Cohesion: 0.14
Nodes (14): FormState, _autovalidateMode, _confirmPasswordController, createState, dispose, _emailController, formKey, initState (+6 more)

### Community 43 - "onboarding_view_body.dart"
Cohesion: 0.17
Nodes (12): build, createState, _currentPage, dispose, initState, OnboardingViewBody, _OnboardingViewBodyState, _pageController (+4 more)

### Community 44 - "email_confirmation_and_auth_flow_test.dart"
Cohesion: 0.09
Nodes (21): FakeNetworkInfo, HttpOverrides, async, authRepo, connected, createHttpClient, fakeApiSource, fakeUserCache (+13 more)

### Community 45 - "downloads_cubit_test.dart"
Cohesion: 0.11
Nodes (18): FakeArticlesLocalDataSource, required String title,
  String, author, clearAllDownloadedArticles, createTestArticle, cubit, deleteDownloadedArticle, deleteUseCase (+10 more)

### Community 46 - "send_code_view_body.dart"
Cohesion: 0.15
Nodes (13): _autovalidateMode, build, _buildEmailField, _buildHeader, _buildInstructions, createState, dispose, _email (+5 more)

### Community 47 - "duplicate_signup_test.dart"
Cohesion: 0.16
Nodes (12): SignupUseCase, build, routeName, signupCubit, SignUpView, package:mind_feed/features/auth/domain/usecases/signup_use_case.dart, package:mind_feed/features/auth/presentation/widgets/sign_up_view_body.dart, call (+4 more)

### Community 48 - "constants.dart"
Cohesion: 0.13
Nodes (14): AppConstants, appName, authConfirmRedirectUrl, compact, hasCompletedCategoriesKey, isOnboardingSeenKey, page, roomy (+6 more)

### Community 49 - "categories_cubit.dart"
Cohesion: 0.18
Nodes (17): CategoriesFailure, CategoriesInitial, CategoriesLoading, CategoriesSelectionChanged, CategoriesState, CategoriesSuccess, errorMessage, isPendingSync (+9 more)

### Community 50 - "StatelessWidget"
Cohesion: 0.04
Nodes (50): Color, build, DraftsEmptyView, DraftsErrorView, message, onRetry, onWriteNew, actionText (+42 more)

### Community 51 - "custom_drawer.dart"
Cohesion: 0.12
Nodes (14): build, ListSavedArticles, routeName, build, CustomDrawer, routeName, build, package:mind_feed/features/collections/presentation/views/articles_saved.dart (+6 more)

### Community 52 - "Fake"
Cohesion: 0.12
Nodes (21): Fake, _client, getCategories, getFavoriteCategories, getProfile, ProfileRemoteDataSource, ProfileRemoteDataSourceImpl, saveFavoriteCategoriesToProfile (+13 more)

### Community 53 - "login_category_check_test.dart"
Cohesion: 0.07
Nodes (37): email, errorMessage, LoginFailure, LoginInitial, LoginLoading, LoginRequiresCategories, LoginState, LoginSuccess (+29 more)

### Community 54 - "package:mind_feed/core/constants/app_colors.dart"
Cohesion: 0.05
Nodes (44): build, buttonText, CustomButton, height, isLoading, build, ForgetPasswordText, build (+36 more)

### Community 55 - "main_navigation_bar.dart"
Cohesion: 0.11
Nodes (17): IconData, build, category, CategoryCard, icon, isSelected, onTap, title (+9 more)

### Community 56 - "editorial_saved_stack.dart"
Cohesion: 0.17
Nodes (12): build, _buildDismissibleCard, createState, _deleteItem, didUpdateWidget, EditorialSavedStack, _EditorialSavedStackState, initState (+4 more)

### Community 57 - "shared_preferences_singleton.dart"
Cohesion: 0.17
Nodes (11): clear, getBool, getKeys, getString, init, _instance, remove, setBool (+3 more)

### Community 58 - "add_article.dart"
Cohesion: 0.11
Nodes (18): AddArticleView, _AddArticleViewState, build, _contentController, _coverUrlController, createState, dispose, initialItem (+10 more)

### Community 59 - "main_view.dart"
Cohesion: 0.18
Nodes (11): build, createState, initState, MainView, _MainViewState, routeName, savedRefreshSeed, selectedIndex (+3 more)

### Community 60 - "article_view.dart"
Cohesion: 0.10
Nodes (24): ArticleReaderCubit, ArticleReaderState, ArticleView, _ArticleViewContent, _ArticleViewContentState, build, createState, cubit (+16 more)

### Community 61 - "MindFeed Editorial UI Transformation Plan"
Cohesion: 0.20
Nodes (9): Architecture decisions, Baseline evidence, Final validation, Goal, MindFeed Editorial UI Transformation Plan, Reference UI description, S1 — Editorial reading shell, S2 — Auth refinement (+1 more)

### Community 62 - "Hermes Review Result: S1-editorial-shell"
Cohesion: 0.20
Nodes (9): Executor evidence, Hermes Review Result: S1-editorial-shell, Independent validation, Recovery decision, Remaining failures or unverified claims, Requirement findings, Scope review, Security and safety (+1 more)

### Community 63 - "categories_view.dart"
Cohesion: 0.20
Nodes (9): build, _buildCubit, categoriesCubit, CategoriesView, profileRemoteDataSource, routeName, userEntity, package:mind_feed/features/auth/presentation/widgets/categories_view_body.dart (+1 more)

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
Cohesion: 0.22
Nodes (8): ArticleReaderMarkdownBody, ArticleReaderTagsWrap, build, content, excerpt, tags, title, package:markdown_widget/markdown_widget.dart

### Community 68 - "settings_archive_section.dart"
Cohesion: 0.15
Nodes (12): build, cachedMegabytes, dataPreservation, onClearCache, onDataPreservationChanged, onSignOut, onWifiOnlyChanged, SettingsArchiveSection (+4 more)

### Community 69 - "Orchestration State"
Cohesion: 0.25
Nodes (7): Active file leases, Blockers and decisions, Last verified checkpoint, Milestones, Orchestration State, Project, Stage tracker

### Community 70 - "editorial_models.dart"
Cohesion: 0.07
Nodes (29): authorAvatar, authorId, authorKey, authorName, authorRatingAvg, authorRatingCount, authorRole, badge (+21 more)

### Community 71 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.13
Nodes (24): AddArticleCubit, ArticleCategorySelector, build, ArticleContentField, build, controller, ArticleCoverImageField, build (+16 more)

### Community 72 - "signup_params.dart"
Cohesion: 0.25
Nodes (7): displayName, email, password, SignupParams, toJson, toSignUpJson, toUpdateDisplayNameJson

### Community 73 - "search_cubit.dart"
Cohesion: 0.06
Nodes (34): message, props, query, results, CategoryEntity? get, _activeRequestId, _applyFiltersAndEmit, close (+26 more)

### Community 74 - "home_lead_story_section.dart"
Cohesion: 0.07
Nodes (24): build, EditorialCard, item, onLike, onOpen, onSave, onShare, showActions (+16 more)

### Community 75 - "ProfileArticlesCubit"
Cohesion: 0.14
Nodes (22): ProfileArticlesCubit, articles, draftCount, message, ProfileArticlesEmpty, ProfileArticlesError, ProfileArticlesInitial, ProfileArticlesLoaded (+14 more)

### Community 76 - "article_data_and_domain_test.dart"
Cohesion: 0.06
Nodes (32): package:mind_feed/features/home/data/repos/articles_repo_impl.dart, articles, async, categories, connected, deleteArticle, getArticleById, getArticlesByAuthor (+24 more)

### Community 77 - "Design Context"
Cohesion: 0.29
Nodes (6): Aesthetic Direction, Brand Personality, Design Context, Design Principles, Quality Bar, Users

### Community 78 - "settings_menu.dart"
Cohesion: 0.15
Nodes (12): build, buildSettingsMenuItem, buildSettingsMenuItemSwitcher, buildSettingsMenuItemWithDropMenu, children, icon, onTap, SettingsMenu (+4 more)

### Community 79 - "package:mind_feed/core/design/editorial_models.dart"
Cohesion: 0.12
Nodes (16): _authorStories, AuthorView, _AuthorViewState, build, createState, initState, _loadAuthorStories, routeName (+8 more)

### Community 80 - "check_code_controller.dart"
Cohesion: 0.08
Nodes (23): BuildContext, _authSubscription, autovalidateMode, codeController, context, _cooldownTimer, dispose, _disposed (+15 more)

### Community 81 - "Project Context: Mind Feed"
Cohesion: 0.33
Nodes (5): 1. Overview, 2. Architecture & Directory Structure, 3. Technology Stack & Key Libraries, 4. Recent Project Changes, Project Context: Mind Feed

### Community 82 - "offline_articles_and_logout_test.dart"
Cohesion: 0.10
Nodes (20): GoTrueClient, GoTrueClient get, package:mind_feed/features/auth/data/repos/auth_repo_impl.dart, async, auth, authClient, clearAllCalled, clearAllDownloadedArticles (+12 more)

### Community 83 - "setup_service_locator.dart"
Cohesion: 0.06
Nodes (39): ../controllers/add_article_cubit_test.dart, CurrentUserSnapshot? get, getIt, setupServiceLocator, ImageDimensionResolver, _currentUser, dimensionResolver, getCategoriesUseCase (+31 more)

### Community 84 - "package:mind_feed/core/constants/app_images.dart"
Cohesion: 0.07
Nodes (24): ArticlePreviewHeader, build, _buildAuthorRow, _buildCoverImage, _buildTagsWrap, _buildTopBar, item, build (+16 more)

### Community 85 - "check_code_view_body.dart"
Cohesion: 0.14
Nodes (14): AutovalidateMode, CheckCodeController, build, CheckCodeViewBody, _CheckCodeViewBodyState, _controller, createState, dispose (+6 more)

### Community 86 - "sign_up_view_body.dart"
Cohesion: 0.10
Nodes (19): build, ChangePasswordViewBody, email, build, LoginViewBody, _handleState, build, SignUpViewBody (+11 more)

### Community 87 - "login_params.dart"
Cohesion: 0.40
Nodes (4): email, LoginParams, password, toJson

### Community 88 - "downloaded_article_entity.dart"
Cohesion: 0.09
Nodes (21): DateTime, authorAvatar, authorName, authorRole, categoryId, categorySlug, content, copyWith (+13 more)

### Community 90 - "package:equatable/equatable.dart"
Cohesion: 0.25
Nodes (7): TagModel, id, name, props, slug, TagEntity, package:equatable/equatable.dart

### Community 92 - "3. Monolithic Files Exceeding 250 Lines"
Cohesion: 0.08
Nodes (24): 1. Executive Summary, 2.1 Transport Leaks in Domain Layer, 2.2 Shallow Modules (1-Line Use Case Indirections), 2.3 Dead Injections & Misleading Seams, 2.4 False Semantics in Local Cache DataSource, 2.5 Global Mutable State Leaking Cross-Feature, 2.6 Dual Conflicting Cache Implementations, 2. Architectural Seams & Layering Violations (+16 more)

### Community 93 - "articles_remote_data_source.dart"
Cohesion: 0.06
Nodes (31): _articleSelectQuery, ArticlesRemoteDataSource, ArticlesRemoteDataSourceImpl, _client, deleteArticle, getArticleById, getArticlesByAuthor, getArticlesByCategory (+23 more)

### Community 94 - "articles_repo_impl.dart"
Cohesion: 0.07
Nodes (28): clearDownloadedArticles, deleteArticle, getArticleById, getArticlesByAuthor, getArticlesByCategory, getAuthorRatingSummary, getCategories, getFixedTags (+20 more)

### Community 95 - "cache_helper.dart"
Cohesion: 0.13
Nodes (14): Box, box, clearData, containsKey, getData, getDataFromHive, getDataString, kBoxName (+6 more)

### Community 96 - "articles_repo.dart"
Cohesion: 0.07
Nodes (29): authorKey, clearDownloadedArticles, deleteArticle, fromJson, getArticleById, getArticlesByAuthor, getArticlesByCategory, getAuthorRatingSummary (+21 more)

### Community 97 - "2. Technical Implementation Boundaries"
Cohesion: 0.11
Nodes (17): 1. Critical Schema & Architectural Reconciliations, 2.1 Feed Ranking & Category Prioritization, 2.2 Content & Image Validation, 2.3 Search, Filtering & Pagination, 2.4 Star & Bookmark Separation, 2.5 Offline Text-Only Storage (BR-04, BR-06), 2.6 Immutability & Deletion Retention, 2. Technical Implementation Boundaries (+9 more)

### Community 98 - "auth_api_source.dart"
Cohesion: 0.12
Nodes (16): authConfirmRedirectUrl, _client, currentUser, login, onAuthStateChange, resendOtp, resetPassword, signInWithGoogle (+8 more)

### Community 99 - "check_app_startup_use_case.dart"
Cohesion: 0.20
Nodes (9): ../entities/startup_destination.dart, AuthApiSource, _authApiSource, call, _cleanupIncompleteSession, _hasActiveSession, _hasCompletedCategories, package:mind_feed/features/auth/data/datasources/auth_api_source.dart (+1 more)

### Community 100 - "home_feed_cubit_test.dart"
Cohesion: 0.07
Nodes (28): _FakeProfileRepo, call, repo, ToggleStarUseCase, allCategories, articles, bookmarkFail, failureMessage (+20 more)

### Community 101 - "Cubit"
Cohesion: 0.19
Nodes (13): cachedMegabytes, copyWith, dataPreservation, SettingsInitial, SettingsLoaded, SettingsState, wifiOnly, Cubit (+5 more)

### Community 102 - "Equatable"
Cohesion: 0.14
Nodes (13): Equatable, ArticleFormErrors, AddArticleState, AuthResultEntity, DownloadsState, ArticleModel, copyWith, fromEntity (+5 more)

### Community 103 - "drafts_cubit_test.dart"
Cohesion: 0.17
Nodes (15): add_article_cubit_test.dart, FakeArticlesRepository, drafts, DraftsEmpty, DraftsError, DraftsInitial, DraftsLoaded, DraftsLoading (+7 more)

### Community 104 - "article_validator.dart"
Cohesion: 0.08
Nodes (24): ArticleValidator, categoryError, computeReadingTime, contentError, copyWith, countWords, coverImageUrlError, defaultImageDimensionResolver (+16 more)

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
Nodes (14): _autovalidateMode, build, _buildConfirmPasswordField, _buildNewPasswordField, _buildRequirements, ChangePasswordForm, _ChangePasswordFormState, _confirmPassword (+6 more)

### Community 111 - "custom_loading_indecator.dart"
Cohesion: 0.15
Nodes (14): dart:math, build, color, _controller, createState, CustomLoadingIndecator, CustomLoadingIndicator, _CustomLoadingIndicatorState (+6 more)

### Community 112 - "failures.dart"
Cohesion: 0.43
Nodes (6): CacheFailure, Failure, message, props, ServerFailure, ValidationFailure

### Community 113 - "home_breathing_background.dart"
Cohesion: 0.20
Nodes (10): Animation, AnimationController, _breathingAnimation, _breathingController, build, createState, dispose, HomeBreathingBackground (+2 more)

### Community 114 - "splash_cubit.dart"
Cohesion: 0.22
Nodes (8): ../../../domain/entities/startup_destination.dart, ../../../domain/usecases/check_app_startup_use_case.dart, Duration, CheckAppStartupUseCase, _checkAppStartupUseCase, initApp, _minDisplayDuration, splash_state.dart

### Community 115 - "widget_test.dart"
Cohesion: 0.08
Nodes (24): package:mind_feed/features/main/presentation/views/main_view.dart, package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart, clearDownloadedArticles, deleteArticle, editorialHarness, getArticleById, getArticlesByAuthor, getArticlesByCategory (+16 more)

### Community 116 - "api_result.dart"
Cohesion: 0.39
Nodes (7): ApiResult, data, failure, FailureResult, Success, R, T

### Community 117 - "article_reader_deps.dart"
Cohesion: 0.10
Nodes (20): articlesRepository, downloadArticleTextUseCase, getArticleDetailsUseCase, getAuthorRatingUseCase, localDataSource, mapToDownloadedEntity, rateAuthorUseCase, resolveArticlesRepo (+12 more)

### Community 118 - "profile_articles_cubit.dart"
Cohesion: 0.08
Nodes (23): fake_articles_repository.dart, articlesRepository, deleteArticleUseCase, deleteDraft, loadDrafts, call, DeleteArticleUseCase, repo (+15 more)

### Community 119 - "package:mind_feed/core/constants/app_icons.dart"
Cohesion: 0.05
Nodes (38): build, MoreVertIcon, build, CheckCodeActionsSection, CheckCodeHeader, email, errorMessageListenable, isLoadingListenable (+30 more)

### Community 120 - "add_article_state.dart"
Cohesion: 0.08
Nodes (25): availableTags, categories, content, contentWordCount, copyWith, coverImageUrl, editingItemId, editingItemStatus (+17 more)

### Community 121 - "login_form.dart"
Cohesion: 0.15
Nodes (13): GlobalKey, _autovalidateMode, build, createState, dispose, _emailController, formKey, initState (+5 more)

### Community 122 - "check_code_args.dart"
Cohesion: 0.50
Nodes (3): CheckCodeArgs, email, isPasswordReset

### Community 123 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.12
Nodes (14): Map, package:flutter_test/flutter_test.dart, package:flutter/widgets.dart, package:mind_feed/features/auth/presentation/views/categories_view.dart, main, allCategories, getCategories, getFavoriteCategories (+6 more)

### Community 124 - "string_extension.dart"
Cohesion: 0.22
Nodes (8): capitalize, reversed, StringExtension, toDateTime, toDouble, toInt, toNum, String get

### Community 125 - "forget_password_flow_test.dart"
Cohesion: 0.10
Nodes (19): _FakeAuthRepository, package:mind_feed/features/auth/presentation/views/change_password_view.dart, package:mind_feed/features/auth/presentation/views/send_code_view.dart, fakeRepo, forgetPassword, forgetPasswordResult, forgetPasswordUseCase, lastForgetPasswordEmail (+11 more)

### Community 127 - "home_view_body.dart"
Cohesion: 0.06
Nodes (33): HomeFeedCubit, HomeFeedState, build, build, cubit, HomeViewBody, _HomeViewBodyContent, build (+25 more)

### Community 128 - "package:mind_feed/features/home/domain/repos/articles_repo.dart"
Cohesion: 0.07
Nodes (33): ArticlesRepository, call, GetArticleDetailsUseCase, repo, call, GetArticlesByCategoryUseCase, repo, call (+25 more)

### Community 130 - "DraftsCubit"
Cohesion: 0.14
Nodes (19): DraftsCubit, build, DraftsView, _handleStateNotification, _openAddArticle, _openPreview, build, _buildActionsRow (+11 more)

### Community 131 - "auth_forms_test.dart"
Cohesion: 0.13
Nodes (13): build, SignUpForm, package:mind_feed/features/auth/presentation/widgets/password_text_field.dart, package:mind_feed/features/auth/presentation/widgets/sign_up_form_body.dart, forgetPassword, login, logout, main (+5 more)

### Community 132 - "article_slow_scroll_bar.dart"
Cohesion: 0.12
Nodes (17): bool get, ArticleSlowScrollBar, _ArticleSlowScrollBarState, availablePaces, build, createState, currentPace, didUpdateWidget (+9 more)

### Community 133 - "package:mind_feed/core/errors/failures.dart"
Cohesion: 0.14
Nodes (13): ArticlesRepositoryImpl, ArticleEngagementRepository, call, GetAuthorRatingUseCase, RateAuthorUseCase, repository, call, repository (+5 more)

### Community 134 - "article_reader_header.dart"
Cohesion: 0.07
Nodes (28): ../controllers/splash_cubit/splash_cubit.dart, ../controllers/splash_cubit/splash_state.dart, ArticleReaderAuthorBar, ArticleReaderCoverImage, ArticleReaderMetadataHeader, authorAvatar, authorName, authorRatingAvg (+20 more)

### Community 135 - "user_cache_source.dart"
Cohesion: 0.18
Nodes (10): dart:convert, CacheHelper, cacheHelper, getUser, key, UserCacheDataSource, package:mind_feed/core/database/cache/cache_helper.dart, package:mind_feed/core/errors/exceptions.dart (+2 more)

### Community 136 - "downloaded_articles_view_body.dart"
Cohesion: 0.24
Nodes (9): DownloadsCubit, DownloadedArticlesView, build, DownloadedArticlesViewBody, package:mind_feed/core/widgets/custom_app_bar.dart, package:mind_feed/features/collections/presentation/cubit/downloads/downloads_cubit.dart, package:mind_feed/features/collections/presentation/cubit/downloads/downloads_state.dart, package:mind_feed/features/collections/presentation/widgets/downloaded_article_card_tile.dart (+1 more)

### Community 137 - "downloaded_articles_view.dart"
Cohesion: 0.29
Nodes (6): build, cubit, routeName, package:mind_feed/features/collections/presentation/widgets/downloaded_articles_view_body.dart, package:mind_feed/features/home/presentation/widgets/custom_drawer.dart, package:mind_feed/features/home/presentation/widgets/custombackground_for_the_drawer_in_home_page.dart

### Community 138 - "UserEntity"
Cohesion: 0.20
Nodes (9): @HiveType, UserModel, copyWith, email, favoriteCategories, token, UserEntity, userName (+1 more)

### Community 139 - "forget_password_cubit.dart"
Cohesion: 0.23
Nodes (13): email, errorMessage, ForgetPasswordFailure, ForgetPasswordInitial, ForgetPasswordLoading, ForgetPasswordState, ForgetPasswordSuccess, ForgetPasswordUseCase (+5 more)

### Community 140 - "downloads_cubit.dart"
Cohesion: 0.07
Nodes (30): downloads_state.dart, _applyFilter, deleteDownload, _deleteDownloadedArticleUseCase, filterArticles, _getDownloadedArticlesUseCase, loadDownloads, _localDataSource (+22 more)

### Community 141 - "password_text_field.dart"
Cohesion: 0.18
Nodes (11): FocusNode, build, controller, createState, dispose, hintText, _isObscured, onChanged (+3 more)

### Community 142 - "article_reader_state.dart"
Cohesion: 0.10
Nodes (19): ArticleReaderStatus, authorRatingAvg, authorRatingCount, copyWith, errorMessage, isDownloaded, isLiked, isSaved (+11 more)

### Community 143 - "SplashCubit"
Cohesion: 0.62
Nodes (6): SplashCubit, SplashInitial, SplashNavigateToLogin, SplashNavigateToMain, SplashNavigateToOnboarding, SplashState

### Community 144 - "change_password_cubit.dart"
Cohesion: 0.29
Nodes (11): ChangePasswordFailure, ChangePasswordInitial, ChangePasswordLoading, ChangePasswordState, ChangePasswordSuccess, errorMessage, ChangePasswordCubit, updatePassword (+3 more)

### Community 145 - "current_user_session.dart"
Cohesion: 0.14
Nodes (13): dart:async, avatarUrl, cacheUserCategories, currentUserId, CurrentUserSession, CurrentUserSnapshot, displayName, email (+5 more)

### Community 146 - "downloads_state.dart"
Cohesion: 0.20
Nodes (9): allArticles, copyWith, DownloadsStatus, errorMessage, feedbackMessage, filteredArticles, props, searchQuery (+1 more)

### Community 147 - "custom_text_field.dart"
Cohesion: 0.07
Nodes (27): build, CustomTextField, hintText, keyboardType, obscureText, onChanged, prefixIcon, suffixIcon (+19 more)

### Community 148 - "datasources/articles_local_data_source.dart"
Cohesion: 0.20
Nodes (9): _box, boxName, clearAllDownloadedArticles, deleteDownloadedArticle, getDownloadedArticleById, getDownloadedArticles, _openBox, saveDownloadedArticle (+1 more)

### Community 149 - "articles_category_view.dart"
Cohesion: 0.40
Nodes (4): ArticlesCategoryView, build, routeName, static const

### Community 150 - "search_view.dart"
Cohesion: 0.19
Nodes (13): SearchEmpty, SearchError, SearchInitial, SearchLoading, SearchState, SearchCubit, build, routeName (+5 more)

### Community 151 - "article_view_widget_test.dart"
Cohesion: 0.20
Nodes (9): package:mind_feed/features/home/domain/usecases/rate_author_use_case.dart, package:mind_feed/features/home/presentation/cubit/article_reader/article_reader_cubit.dart, package:mind_feed/features/home/presentation/widgets/widgets/article_slow_scroll_bar.dart, getAuthorRatingSummary, isArticleLiked, likeArticle, main, rateAuthor (+1 more)

### Community 152 - "articles_saved.dart"
Cohesion: 0.17
Nodes (12): ArticlesSaved, _ArticlesSavedContent, _ArticlesSavedContentState, build, createState, didUpdateWidget, dispose, initState (+4 more)

### Community 153 - "Exception?"
Cohesion: 0.60
Nodes (4): Exception?, CacheException, NoInternetException, ServerException

### Community 154 - "author_rating_and_like_data_test.dart"
Cohesion: 0.15
Nodes (12): AuthorRatingSummary, package:mind_feed/features/home/data/models/article_model.dart, package:mind_feed/features/home/domain/usecases/toggle_article_like_use_case.dart, currentSummary, getAuthorRatingSummary, isArticleLiked, likeArticle, likedArticles (+4 more)

### Community 155 - "profile_avatar_and_stats.dart"
Cohesion: 0.13
Nodes (13): build, ProfileView, routeName, articlesCount, avatarUrl, build, _buildStatItem, displayName (+5 more)

### Community 156 - "List"
Cohesion: 0.11
Nodes (16): categories, CategoryItem, icon, name, accessToken, email, hasActiveSession, props (+8 more)

### Community 157 - "package:supabase_flutter/supabase_flutter.dart"
Cohesion: 0.22
Nodes (8): ../errors/exceptions.dart, ../errors/failures.dart, ApiErrorHandler, code, handle, message, toFailure, package:supabase_flutter/supabase_flutter.dart

### Community 158 - "package:mind_feed/features/home/domain/entities/tag_entity.dart"
Cohesion: 0.22
Nodes (7): fromEntity, fromJson, toJson, call, GetFixedTagsUseCase, repo, package:mind_feed/features/home/domain/entities/tag_entity.dart

### Community 159 - "home_feed_state.dart"
Cohesion: 0.22
Nodes (8): allArticles, copyWith, errorMessage, HomeFeedStatus, props, selectedTopic, status, topics

### Community 160 - "settings_dialogs.dart"
Cohesion: 0.22
Nodes (8): context, options, showDialog, showDigestPickerSheet, showEditProfileSheet, showModalBottomSheet, showPrivacyManifestDialog, showSignOutDialog

### Community 161 - "custom_app_bar.dart"
Cohesion: 0.13
Nodes (13): AdvancedDrawerController, AdvancedDrawerValue, build, CustomAppBar, _handleMenuButtonPressed, title, advancedDrawerController, build (+5 more)

### Community 162 - "static const String"
Cohesion: 0.12
Nodes (13): addArticle, AddArticleRoutes, articlePreview, drafts, build, OnboardingView, routeName, build (+5 more)

### Community 163 - "change_password_view.dart"
Cohesion: 0.25
Nodes (7): build, ChangePasswordView, cubit, email, routeName, package:mind_feed/features/auth/presentation/controllers/change_password_cubit/change_password_cubit.dart, package:mind_feed/features/auth/presentation/widgets/change_password_view_body.dart

### Community 164 - "splash_logo_widget.dart"
Cohesion: 0.25
Nodes (8): _breathingAnimation, _breathingController, build, createState, dispose, initState, SplashLogoWidget, _SplashLogoWidgetState

### Community 165 - "package:mind_feed/core/networking/api_result.dart"
Cohesion: 0.07
Nodes (29): AuthRepoImpl, AuthRepository, call, repo, articlesRepo, authRepo, call, localDataSource (+21 more)

### Community 166 - "user_articles_widget_test.dart"
Cohesion: 0.14
Nodes (12): build, ProfileViewBody, package:mind_feed/features/profile/presentation/widget/personal_infromation.dart, package:mind_feed/features/profile/presentation/widget/profile_app_bar.dart, package:mind_feed/features/profile/presentation/widget/user_articles.dart, buildTestWidget, deleteUseCase, draftItem1 (+4 more)

### Community 167 - "check_code_view.dart"
Cohesion: 0.29
Nodes (6): build, CheckCodeView, email, isPasswordReset, routeName, package:mind_feed/features/auth/presentation/widgets/check_code_view_body.dart

### Community 168 - "send_code_view.dart"
Cohesion: 0.29
Nodes (6): build, cubit, routeName, SendCodeView, package:mind_feed/features/auth/presentation/controllers/forget_password_cubit/forget_password_cubit.dart, package:mind_feed/features/auth/presentation/widgets/send_code_view_body.dart

### Community 169 - "_"
Cohesion: 0.17
Nodes (12): SearchLoaded, _, copyStateWithFilters, filterByTags, mapFailureMessage, SearchFilterHelper, toggleTag, package:mind_feed/features/search/domain/helpers/search_filter_helper.dart (+4 more)

### Community 170 - "package:flutter/foundation.dart"
Cohesion: 0.25
Nodes (7): Client, http.BaseClient, _inner, send, SupabaseInterceptor, package:flutter/foundation.dart, package:http/http.dart

### Community 171 - "article_payload_builder.dart"
Cohesion: 0.25
Nodes (7): ArticlePayloadBuilder, buildDraftPayload, buildPublishPayload, resolveAuthorName, resolveEditLockoutError, validateStateForPublish, package:mind_feed/features/add_article/domain/helpers/article_validator.dart

### Community 172 - "article_field_helpers.dart"
Cohesion: 0.25
Nodes (7): articleInputDecoration, ArticleSectionHeader, build, counter, isCounterError, isCounterSuccess, title

### Community 173 - "downloaded_article_card_tile.dart"
Cohesion: 0.25
Nodes (7): article, build, DownloadedArticleCardTile, _formatDate, isDark, onDelete, MaterialPageRoute

### Community 174 - "DownloadedArticleEntity"
Cohesion: 0.67
Nodes (3): DownloadedArticleEntity, DownloadedArticleEntityAdapter, TypeAdapter

### Community 175 - "profile_repo.dart"
Cohesion: 0.25
Nodes (7): getCategories, getFavoriteCategories, getProfile, reconcilePendingCategorySync, saveLocalCategories, syncFavoriteCategories, updateProfile

### Community 176 - "categories_view_body.dart"
Cohesion: 0.29
Nodes (6): build, CategoriesViewBody, userEntity, package:mind_feed/core/widgets/custom_button.dart, package:mind_feed/features/auth/presentation/controllers/categories_cubit/categories_cubit.dart, package:mind_feed/features/auth/presentation/widgets/category_card.dart

### Community 177 - "repos/articles_local_data_source.dart"
Cohesion: 0.33
Nodes (5): clearAllDownloadedArticles, deleteDownloadedArticle, getDownloadedArticleById, getDownloadedArticles, saveDownloadedArticle

### Community 178 - "package:mind_feed/core/utls/setup_service_locator.dart"
Cohesion: 0.33
Nodes (5): MethodChannel, package:mind_feed/core/networking/network_info.dart, package:mind_feed/core/utls/setup_service_locator.dart, channel, main

### Community 179 - "article_view_body.dart"
Cohesion: 0.40
Nodes (4): ArticleViewBody, build, item, package:mind_feed/features/home/presentation/views/article_view.dart

### Community 180 - "get_categories_use_case.dart"
Cohesion: 0.50
Nodes (3): call, GetCategoriesUseCase, repo

## Knowledge Gaps
- **2231 isolated node(s):** `capitalize`, `reversed`, `toInt`, `toDouble`, `toNum` (+2226 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 2445 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `UserEntity` connect `UserEntity` to `category_onboarding_clean_architecture_test.dart`, `main.dart`, `settings_view_body.dart`, `category_sync_hardening_test.dart`, `signup_cubit.dart`, `current_user_session.dart`, `auth_repo_impl.dart`, `categories_view_body.dart`, `offline_articles_and_logout_test.dart`, `login_category_check_test.dart`, `profile_repo_impl.dart`, `categories_view.dart`, `cache_helper.dart`?**
  _High betweenness centrality (0.014) - this node is a cross-community bridge._
- **Why does `ProfileRemoteDataSource` connect `Fake` to `profile_repo_impl.dart`, `setup_service_locator.dart`, `categories_view.dart`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Why does `AddArticleCubit` connect `package:flutter_bloc/flutter_bloc.dart` to `Cubit`, `Equatable`, `setup_service_locator.dart`, `add_article_cubit_test.dart`, `add_article.dart`?**
  _High betweenness centrality (0.009) - this node is a cross-community bridge._
- **What connects `capitalize`, `reversed`, `toInt` to the rest of the system?**
  _2231 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.01652892561983471 - nodes in this community are weakly interconnected._
- **Should `app_icons.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.020833333333333332 - nodes in this community are weakly interconnected._
- **Should `category_onboarding_clean_architecture_test.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.07407407407407407 - nodes in this community are weakly interconnected._