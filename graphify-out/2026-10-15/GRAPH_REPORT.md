# Graph Report - MindFeed-main  (2026-10-15)

## Corpus Check
- 238 files · ~226,563 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2299 nodes · 3429 edges · 135 communities
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `760de4a1`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- app_colors.dart
- app_icons.dart
- category_onboarding_clean_architecture_test.dart
- app_text_styles.dart
- setup_service_locator.dart
- editorial_card_stack.dart
- home_of_add_article_view.dart
- custom_text_field.dart
- app_routes.dart
- package:flutter_bloc/flutter_bloc.dart
- app_theme_data.dart
- category_sync_hardening_test.dart
- collections_cubit.dart
- markdown_text_input.dart
- Business Requirements Document (BRD)
- StatelessWidget
- signup_cubit.dart
- auth_repo_impl.dart
- package:flutter/material.dart
- Mini-requirements
- Continuation Packet: S1-editorial-shell-recovery
- package:mind_feed/core/constants/app_colors.dart
- package:mind_feed/core/constants/app_text_styles.dart
- package:mind_feed/core/constants/app_images.dart
- Task Packet: S1-editorial-shell
- Task Packet: S2-auth-refinement
- NetworkInfo
- profile_repo_impl.dart
- editorial_design.dart
- splash_test.dart
- auth_repo.dart
- device_preference_notifier.dart
- list_card.dart
- borders.dart
- theme_config.dart
- format_markdown.dart
- MindFeed Editorial UI Specification & Architecture
- package:mind_feed/core/constants/app_icons.dart
- package:mind_feed/core/constants/constants.dart
- settings_view_body.dart
- Mind Feed
- article_entity.dart
- sign_up_form_body.dart
- onboarding_view_body.dart
- email_confirmation_and_auth_flow_test.dart
- custom_app_bar.dart
- login_form.dart
- duplicate_signup_test.dart
- auth_forms_test.dart
- categories_cubit.dart
- category_card.dart
- custom_drawer.dart
- Fake
- login_cubit.dart
- theme_mode_cubit.dart
- package:mind_feed/core/constants/borders.dart
- editorial_saved_stack.dart
- shared_preferences_singleton.dart
- downloaded_articles_view_body.dart
- main_view.dart
- article_view.dart
- MindFeed Editorial UI Transformation Plan
- Hermes Review Result: S1-editorial-shell
- string_extension.dart
- MindFeed Phase 0 — Repository and Live Database Reconciliation Report
- @immutable
- constants.dart
- splash_logo_widget.dart
- package:flutter/foundation.dart
- Orchestration State
- login_view.dart
- main.dart
- signup_params.dart
- add_article.dart
- user_entity.dart
- user_articles.dart
- article_data_and_domain_test.dart
- Design Context
- package:mind_feed/core/design/editorial_models.dart
- author_view.dart
- datasources/articles_local_data_source.dart
- Project Context: Mind Feed
- offline_articles_and_logout_test.dart
- package:supabase_flutter/supabase_flutter.dart
- home_view.dart
- check_code_view_body.dart
- Exception
- login_params.dart
- downloaded_article_entity.dart
- save_favorite_categories_use_case.dart
- 3. Monolithic Files Exceeding 250 Lines
- articles_remote_data_source.dart
- articles_repo_impl.dart
- cache_helper.dart
- articles_repo.dart
- 2. Technical Implementation Boundaries
- auth_api_source.dart
- categories_view.dart
- home_view_body.dart
- settings_cubit.dart
- article_model.dart
- List
- password_text_field.dart
- MindFeed Phase 1 — Database Baseline & Migration Reconciliation Verification Report
- MindFeed Phase 1 — Database Baseline and Migration Reconciliation Report
- app_images.dart
- Equatable
- logout_use_case.dart
- change_password_form.dart
- _EditorialCardStackState
- failures.dart
- article_card_of_author.dart
- list_saved_articles.dart
- widget_test.dart
- page_view_item.dart
- custom_popup_menu_button_for_article_view.dart
- article_card.dart
- main_navigation_bar.dart
- search_bar.dart
- State
- tag_model.dart
- categories_view_test.dart
- email_text_field.dart
- change_password_view.dart
- build
- package:mind_feed/core/networking/api_result.dart
- check_code_view.dart
- ArticlesRemoteDataSource
- static const String
- Cubit
- AppRoutes.checkCode

## God Nodes (most connected - your core abstractions)
1. `Continuation Packet: S1-editorial-shell-recovery` - 19 edges
2. `Task Packet: S1-editorial-shell` - 18 edges
3. `Task Packet: S2-auth-refinement` - 18 edges
4. `ArticlesRepository` - 17 edges
5. `Mini-requirements` - 16 edges
6. `UserEntity` - 13 edges
7. `SignupCubit` - 13 edges
8. `AddArticleCubit` - 12 edges
9. `AuthRepository` - 12 edges
10. `CategoriesCubit` - 12 edges

## Surprising Connections (you probably didn't know these)
- `MockNetworkInfo` --implements--> `NetworkInfo`  [EXTRACTED]
  test/features/home/article_data_and_domain_test.dart → lib/core/networking/network_info.dart
- `FakeNetworkInfo` --implements--> `NetworkInfo`  [EXTRACTED]
  test/offline_articles_and_logout_test.dart → lib/core/networking/network_info.dart
- `_FakeAuthRepo` --implements--> `AuthRepository`  [EXTRACTED]
  test/auth_forms_test.dart → lib/features/auth/domain/repos/auth_repo.dart
- `FakeArticlesRemoteDataSource` --implements--> `ArticlesRemoteDataSource`  [EXTRACTED]
  test/features/home/article_data_and_domain_test.dart → lib/features/home/data/datasources/articles_remote_data_source.dart
- `FakeArticlesLocalDataSource` --implements--> `ArticlesLocalDataSource`  [EXTRACTED]
  test/offline_articles_and_logout_test.dart → lib/features/home/domain/repos/articles_local_data_source.dart

## Import Cycles
- None detected.

## Communities (135 total, 0 thin omitted)

### Community 0 - "app_colors.dart"
Cohesion: 0.02
Nodes (120): almostBlack, amber, amberDark, amberDarker, black, blue, blueMain, blush (+112 more)

### Community 1 - "app_icons.dart"
Cohesion: 0.03
Nodes (74): add, alternateEmailRounded, AppIcons, arrowBackRounded, arrowForwardIosRounded, articleOutlined, boltRounded, bookmark (+66 more)

### Community 2 - "category_onboarding_clean_architecture_test.dart"
Cohesion: 0.07
Nodes (30): ../errors/failures.dart, ApiResult, data, failure, FailureResult, Success, PostgrestException, R (+22 more)

### Community 3 - "app_text_styles.dart"
Cohesion: 0.09
Nodes (21): bodyLarge, bodyMedium, bodySmall, displayLarge, displayMedium, displaySmall, headlineLarge, headlineMedium (+13 more)

### Community 4 - "setup_service_locator.dart"
Cohesion: 0.09
Nodes (25): getIt, setupServiceLocator, AuthRepoImpl, AuthRepository, call, repo, VerifyOtpUseCase, CategorySyncReconciler (+17 more)

### Community 5 - "editorial_card_stack.dart"
Cohesion: 0.10
Nodes (20): _animController, build, _cards, createState, didUpdateWidget, dispose, _dragOffset, height (+12 more)

### Community 6 - "home_of_add_article_view.dart"
Cohesion: 0.06
Nodes (40): AddArticleError, AddArticleFileLoaded, AddArticleInitial, AddArticleLoading, AddArticleState, content, fileName, message (+32 more)

### Community 7 - "custom_text_field.dart"
Cohesion: 0.17
Nodes (11): build, CustomTextField, hintText, keyboardType, obscureText, onChanged, prefixIcon, suffixIcon (+3 more)

### Community 8 - "app_routes.dart"
Cohesion: 0.05
Nodes (36): addArticle, AppRoutes, article, articlesCategory, articlesSaved, author, categories, changePassword (+28 more)

### Community 9 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.08
Nodes (26): build, ChangePasswordViewBody, email, build, ForgetPasswordText, build, _buildThemeCard, ThemeWidget (+18 more)

### Community 10 - "app_theme_data.dart"
Cohesion: 0.06
Nodes (30): card, checkbox, chip, dialog, dropdownMenu, filledButton, floatingActionButton, iconButton (+22 more)

### Community 11 - "category_sync_hardening_test.dart"
Cohesion: 0.11
Nodes (17): Directory, MockProfileRemoteDataSource, package:mind_feed/features/auth/domain/usecases/logout_use_case.dart, package:mind_feed/features/home/data/datasources/articles_local_data_source.dart, categoriesList, clearAllDownloadedArticles, cleared, getCategories (+9 more)

### Community 12 - "collections_cubit.dart"
Cohesion: 0.21
Nodes (13): CollectionsInitial, CollectionsLoaded, CollectionsLoading, CollectionsState, stories, _allStories, CollectionsCubit, deleteArticle (+5 more)

### Community 13 - "markdown_text_input.dart"
Cohesion: 0.07
Nodes (28): Function, int?, actions, actionWidget, _basicInkwell, build, controller, _controllerListener (+20 more)

### Community 14 - "Business Requirements Document (BRD)"
Cohesion: 0.08
Nodes (24): 1.1 Purpose, 1.2 Business Problem Statement, 1.3 Vision & Solution, 1. Executive Summary, 2. Business Objectives & Key Performance Indicators (KPIs), 3.1 Competitive Landscape, 3.2 Target Audience Segments, 3. Market Analysis & Value Proposition (+16 more)

### Community 15 - "StatelessWidget"
Cohesion: 0.10
Nodes (23): build, buildSettingsMenuItem, buildSettingsMenuItemSwitcher, buildSettingsMenuItemWithDropMenu, children, icon, kicker, onChanged (+15 more)

### Community 16 - "signup_cubit.dart"
Cohesion: 0.25
Nodes (13): email, errorMessage, isUserAlreadyRegistered, SignupFailure, SignupInitial, SignupLoading, SignupRequiresConfirmation, SignupState (+5 more)

### Community 17 - "auth_repo_impl.dart"
Cohesion: 0.07
Nodes (29): dart:convert, ../entities/startup_destination.dart, CacheHelper, AuthApiSource, cacheHelper, getUser, key, UserCacheDataSource (+21 more)

### Community 18 - "package:flutter/material.dart"
Cohesion: 0.07
Nodes (22): customShowSnackBar, duration, build, ListForSavedArticles, build, SavedArticlesViewBody, build, ProfileViewBody (+14 more)

### Community 19 - "Mini-requirements"
Cohesion: 0.09
Nodes (21): 1. Mandatory Authentication & Onboarding, 2. Home Feed & Discovery, 3. Article Reader, Starring & Sharing, 4. Offline Mode (Text-Only), 5. Article Drafting, Preview, Publishing & Lifecycle, 6. Personal Collections & Settings, Acceptance Criteria, Business Rules (+13 more)

### Community 20 - "Continuation Packet: S1-editorial-shell-recovery"
Cohesion: 0.10
Nodes (19): Allowed edit scope, Areas that must not be redesigned, Completed work, Continuation objective, Continuation Packet: S1-editorial-shell-recovery, Current failures, Exact files to inspect, Exact remaining work (+11 more)

### Community 21 - "package:mind_feed/core/constants/app_colors.dart"
Cohesion: 0.07
Nodes (22): build, CustomLoadingIndecator, authBackground, build, CustombackgroundForTheDrawerInHomePage, build, OnboardingView, routeName (+14 more)

### Community 22 - "package:mind_feed/core/constants/app_text_styles.dart"
Cohesion: 0.10
Nodes (16): ArticleCardInformation, author, build, date, title, author, build, date (+8 more)

### Community 23 - "package:mind_feed/core/constants/app_images.dart"
Cohesion: 0.09
Nodes (18): build, Logo, ArticleViewBody, build, build, OnBoardingBackground, pageController, build (+10 more)

### Community 24 - "Task Packet: S1-editorial-shell"
Cohesion: 0.11
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 25 - "Task Packet: S2-auth-refinement"
Cohesion: 0.11
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 26 - "NetworkInfo"
Cohesion: 0.12
Nodes (15): Connectivity, Future, connectivity, isConnected, NetworkInfo, NetworkInfoImpl, MethodChannel, package:connectivity_plus/connectivity_plus.dart (+7 more)

### Community 27 - "profile_repo_impl.dart"
Cohesion: 0.13
Nodes (13): call, PublishArticleUseCase, repo, getCategories, getFavoriteCategories, getProfile, _isReconciling, reconcilePendingCategorySync (+5 more)

### Community 28 - "editorial_design.dart"
Cohesion: 0.12
Nodes (17): authorName, build, _buildShareAction, createState, EditorialFollowButton, _EditorialFollowButtonState, EditorialIconButton, icon (+9 more)

### Community 29 - "splash_test.dart"
Cohesion: 0.08
Nodes (31): ../controllers/splash_cubit/splash_cubit.dart, ../controllers/splash_cubit/splash_state.dart, ../../../domain/entities/startup_destination.dart, ../../../domain/usecases/check_app_startup_use_case.dart, Duration, StartupDestination, StartupLogin, StartupMain (+23 more)

### Community 30 - "auth_repo.dart"
Cohesion: 0.18
Nodes (10): forgetPassword, login, logout, resendOtp, signup, verifyOtp, call, repo (+2 more)

### Community 31 - "device_preference_notifier.dart"
Cohesion: 0.12
Nodes (16): int get, copyWith, DevicePreferenceNotifier, DevicePreferences, hashCode, isDarkMode, isSplitLayout, loadDevicePreferences (+8 more)

### Community 32 - "list_card.dart"
Cohesion: 0.11
Nodes (15): build, CustomSliverAppBarForArticlesSaved, build, isleft, ListCard, listCardBody, build, ChipGroup (+7 more)

### Community 33 - "borders.dart"
Cohesion: 0.12
Nodes (15): card, circular, control, l, m, _main, s, xl (+7 more)

### Community 34 - "theme_config.dart"
Cohesion: 0.07
Nodes (28): app_theme_data.dart, bool?, Color, DynamicSchemeVariant, dark, dynamicSchemeVariant, isAmoledSelected, light (+20 more)

### Community 35 - "format_markdown.dart"
Cohesion: 0.17
Nodes (11): dart:math, convertToMarkdown, cursorIndex, data, FormatMarkdown, image, MarkdownType, replaceCursorIndex (+3 more)

### Community 36 - "MindFeed Editorial UI Specification & Architecture"
Cohesion: 0.13
Nodes (14): 1. Visual Design Language (`lib/core/design/editorial_design.dart`), 2. Reusable Modular Components, 3. Screen Implementations, 4. Documentation & Verification Assets, 5. Automated Tests, Card Component (`lib/core/design/editorial_card.dart`), Data Models & Repository (`lib/core/design/editorial_models.dart`, `editorial_mock_data.dart`), Floating Editorial Navigation (`lib/features/main/presentation/widgets/main_navigation_bar.dart`) (+6 more)

### Community 37 - "package:mind_feed/core/constants/app_icons.dart"
Cohesion: 0.09
Nodes (19): build, MoreVertIcon, build, SecurityTipText, AuthorPersonalInfo, build, _buildStatItem, AuthorAppBar (+11 more)

### Community 38 - "package:mind_feed/core/constants/constants.dart"
Cohesion: 0.22
Nodes (8): build, currentPage, NextButton, pageController, build, SkipButton, package:mind_feed/core/constants/constants.dart, package:mind_feed/core/services/shared_preferences_singleton.dart

### Community 39 - "settings_view_body.dart"
Cohesion: 0.14
Nodes (13): _bionicGuide, _breakingAlerts, build, _cachedMegabytes, createState, _dataPreservation, _fontScale, _morningBriefing (+5 more)

### Community 40 - "Mind Feed"
Cohesion: 0.14
Nodes (13): Architecture, Building APK, Features, Getting Started, Installation, Key Dependencies, License, Mind Feed (+5 more)

### Community 41 - "article_entity.dart"
Cohesion: 0.06
Nodes (35): authorAvatar, authorId, authorName, authorRole, badge, badgeColor, cardColor, categoryId (+27 more)

### Community 42 - "sign_up_form_body.dart"
Cohesion: 0.15
Nodes (13): _autovalidateMode, build, _confirmPasswordController, createState, dispose, _emailController, formKey, initState (+5 more)

### Community 43 - "onboarding_view_body.dart"
Cohesion: 0.17
Nodes (12): build, createState, _currentPage, dispose, initState, OnboardingViewBody, _OnboardingViewBodyState, _pageController (+4 more)

### Community 44 - "email_confirmation_and_auth_flow_test.dart"
Cohesion: 0.09
Nodes (21): FakeNetworkInfo, HttpOverrides, async, authRepo, connected, createHttpClient, fakeApiSource, fakeUserCache (+13 more)

### Community 45 - "custom_app_bar.dart"
Cohesion: 0.12
Nodes (17): AdvancedDrawerValue, build, CustomAppBar, _handleMenuButtonPressed, title, build, DownloadedArticlesView, routeName (+9 more)

### Community 46 - "login_form.dart"
Cohesion: 0.12
Nodes (17): AutovalidateMode, FormState, GlobalKey, _autovalidateMode, createState, dispose, _emailController, formKey (+9 more)

### Community 47 - "duplicate_signup_test.dart"
Cohesion: 0.15
Nodes (14): SignupUseCase, build, routeName, signupCubit, SignUpView, package:mind_feed/core/utls/setup_service_locator.dart, package:mind_feed/features/auth/domain/usecases/signup_use_case.dart, package:mind_feed/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart (+6 more)

### Community 48 - "auth_forms_test.dart"
Cohesion: 0.14
Nodes (12): build, SignUpForm, package:mind_feed/features/auth/presentation/widgets/login_form.dart, package:mind_feed/features/auth/presentation/widgets/password_text_field.dart, package:mind_feed/features/auth/presentation/widgets/sign_up_form_body.dart, forgetPassword, login, logout (+4 more)

### Community 49 - "categories_cubit.dart"
Cohesion: 0.19
Nodes (16): CategoriesFailure, CategoriesInitial, CategoriesLoading, CategoriesSelectionChanged, CategoriesState, CategoriesSuccess, errorMessage, isPendingSync (+8 more)

### Community 50 - "category_card.dart"
Cohesion: 0.09
Nodes (20): actionText, AuthPromptLink, build, onTap, promptText, build, category, CategoryCard (+12 more)

### Community 51 - "custom_drawer.dart"
Cohesion: 0.18
Nodes (10): build, CustomDrawer, routeName, build, package:mind_feed/features/collections/presentation/views/downloaded_articles_view.dart, package:mind_feed/features/collections/presentation/views/favorite_movies_view.dart, package:mind_feed/features/settings/presentation/views/settings_view.dart, AppRoutes.downloadedArticles (+2 more)

### Community 52 - "Fake"
Cohesion: 0.11
Nodes (21): Fake, _client, getCategories, getFavoriteCategories, getProfile, ProfileRemoteDataSource, ProfileRemoteDataSourceImpl, setFavoriteCategories (+13 more)

### Community 53 - "login_cubit.dart"
Cohesion: 0.26
Nodes (12): email, errorMessage, LoginFailure, LoginInitial, LoginLoading, LoginState, LoginSuccess, eitherFailureOrLogin (+4 more)

### Community 54 - "theme_mode_cubit.dart"
Cohesion: 0.38
Nodes (9): ThemeModeDark, ThemeModeInitial, ThemeModeLight, ThemeModeState, ThemeModeSystem, changeThemeMode, getThemeMode, ThemeModeCubit (+1 more)

### Community 55 - "package:mind_feed/core/constants/borders.dart"
Cohesion: 0.07
Nodes (24): build, EditorialCard, item, onLike, onOpen, onSave, onShare, showActions (+16 more)

### Community 56 - "editorial_saved_stack.dart"
Cohesion: 0.17
Nodes (12): build, _buildDismissibleCard, createState, _deleteItem, didUpdateWidget, EditorialSavedStack, _EditorialSavedStackState, initState (+4 more)

### Community 57 - "shared_preferences_singleton.dart"
Cohesion: 0.17
Nodes (11): clear, getBool, getKeys, getString, init, _instance, remove, setBool (+3 more)

### Community 58 - "downloaded_articles_view_body.dart"
Cohesion: 0.17
Nodes (10): build, DownloadedArticlesViewBody, build, FavoriteMoviesViewBody, build, routeName, SearchView, package:mind_feed/core/widgets/custom_app_bar.dart (+2 more)

### Community 59 - "main_view.dart"
Cohesion: 0.25
Nodes (7): build, createState, initState, routeName, selectedIndex, package:mind_feed/features/profile/data/services/category_sync_reconciler.dart, package:mind_feed/features/search/presentation/views/search_view.dart

### Community 60 - "article_view.dart"
Cohesion: 0.17
Nodes (12): _article, ArticleView, _ArticleViewState, build, createState, initState, _isLiked, _isSaved (+4 more)

### Community 61 - "MindFeed Editorial UI Transformation Plan"
Cohesion: 0.20
Nodes (9): Architecture decisions, Baseline evidence, Final validation, Goal, MindFeed Editorial UI Transformation Plan, Reference UI description, S1 — Editorial reading shell, S2 — Auth refinement (+1 more)

### Community 62 - "Hermes Review Result: S1-editorial-shell"
Cohesion: 0.20
Nodes (9): Executor evidence, Hermes Review Result: S1-editorial-shell, Independent validation, Recovery decision, Remaining failures or unverified claims, Requirement findings, Scope review, Security and safety (+1 more)

### Community 63 - "string_extension.dart"
Cohesion: 0.25
Nodes (7): capitalize, reversed, toDateTime, toDouble, toInt, toNum, String get

### Community 64 - "MindFeed Phase 0 — Repository and Live Database Reconciliation Report"
Cohesion: 0.06
Nodes (33): 1. Executive Summary, 2.1 Git Status & Branching, 2.2 Migration & SQL Script Inventory, 2.3 Dependency Registrations & Service Locator (`setup_service_locator.dart`), 2.4 Existing Codebase Architecture & Data Layer, 2. Repository State and Migration Inventory, 3.1 Live Tables & Schema Summary, 3.2 Exact Table Columns & Constraints (+25 more)

### Community 65 - "@immutable"
Cohesion: 0.29
Nodes (7): @immutable, AppThemeData, ThemeConfig, AppColors, AppTextStyles, AppBorders, SharedPreferencesSingleton

### Community 66 - "constants.dart"
Cohesion: 0.14
Nodes (13): AppConstants, appName, authConfirmRedirectUrl, compact, isOnboardingSeenKey, page, roomy, supabaseAnonKey (+5 more)

### Community 67 - "splash_logo_widget.dart"
Cohesion: 0.20
Nodes (10): Animation, AnimationController, _breathingAnimation, _breathingController, build, createState, dispose, initState (+2 more)

### Community 68 - "package:flutter/foundation.dart"
Cohesion: 0.25
Nodes (7): Client, http.BaseClient, _inner, send, SupabaseInterceptor, package:flutter/foundation.dart, package:http/http.dart

### Community 69 - "Orchestration State"
Cohesion: 0.25
Nodes (7): Active file leases, Blockers and decisions, Last verified checkpoint, Milestones, Orchestration State, Project, Stage tracker

### Community 70 - "login_view.dart"
Cohesion: 0.15
Nodes (11): call, LoginUseCase, repo, build, loginCubit, LoginView, routeName, package:mind_feed/core/params/login_params.dart (+3 more)

### Community 71 - "main.dart"
Cohesion: 0.22
Nodes (8): globalDevicePreferenceNotifier, init, initFlutter, initialize, loadDevicePreferences, main, package:mind_feed/core/networking/supabase_interceptor.dart, package:mind_feed/main_app.dart

### Community 72 - "signup_params.dart"
Cohesion: 0.25
Nodes (7): displayName, email, password, SignupParams, toJson, toSignUpJson, toUpdateDisplayNameJson

### Community 73 - "add_article.dart"
Cohesion: 0.25
Nodes (7): AddArticleView, build, MarkdownEditorApp, routeName, package:mind_feed/features/add_article/presentation/views/home_of_add_article_view.dart, package:mind_feed/features/add_article/presentation/widget/device_preference_notifier.dart, package:mind_feed/main.dart

### Community 74 - "user_entity.dart"
Cohesion: 0.29
Nodes (6): copyWith, email, favoriteCategories, token, userName, package:hive_flutter/adapters.dart

### Community 75 - "user_articles.dart"
Cohesion: 0.22
Nodes (9): _articles, build, createState, initState, _loadUserArticles, UserArticles, _UserArticlesState, package:mind_feed/core/design/editorial_mock_data.dart (+1 more)

### Community 76 - "article_data_and_domain_test.dart"
Cohesion: 0.07
Nodes (28): package:mind_feed/features/home/data/repos/articles_repo_impl.dart, package:mind_feed/features/home/domain/usecases/publish_article_use_case.dart, articles, async, categories, connected, deleteArticle, getArticleById (+20 more)

### Community 77 - "Design Context"
Cohesion: 0.29
Nodes (6): Aesthetic Direction, Brand Personality, Design Context, Design Principles, Quality Bar, Users

### Community 78 - "package:mind_feed/core/design/editorial_models.dart"
Cohesion: 0.29
Nodes (6): EditorialMockData, savedStories, stories, userArticles, package:mind_feed/core/design/editorial_models.dart, static List

### Community 79 - "author_view.dart"
Cohesion: 0.20
Nodes (9): _authorStories, build, createState, initState, _loadAuthorStories, routeName, package:mind_feed/features/author/presentation/views/author_personal_info.dart, package:mind_feed/features/author/presentation/widgets/author_app_bar.dart (+1 more)

### Community 80 - "datasources/articles_local_data_source.dart"
Cohesion: 0.07
Nodes (29): ArticlesLocalDataSourceImpl, _box, boxName, clearAllDownloadedArticles, deleteDownloadedArticle, getDownloadedArticleById, getDownloadedArticles, _openBox (+21 more)

### Community 81 - "Project Context: Mind Feed"
Cohesion: 0.33
Nodes (5): 1. Overview, 2. Architecture & Directory Structure, 3. Technology Stack & Key Libraries, 4. Recent Project Changes, Project Context: Mind Feed

### Community 82 - "offline_articles_and_logout_test.dart"
Cohesion: 0.08
Nodes (23): GoTrueClient, GoTrueClient get, package:mind_feed/features/auth/data/repos/auth_repo_impl.dart, package:mind_feed/features/home/domain/usecases/delete_downloaded_article_use_case.dart, package:mind_feed/features/home/domain/usecases/download_article_text_use_case.dart, package:mind_feed/features/home/domain/usecases/get_downloaded_articles_use_case.dart, async, auth (+15 more)

### Community 83 - "package:supabase_flutter/supabase_flutter.dart"
Cohesion: 0.25
Nodes (7): ../errors/exceptions.dart, ApiErrorHandler, code, handle, message, toFailure, package:supabase_flutter/supabase_flutter.dart

### Community 84 - "home_view.dart"
Cohesion: 0.29
Nodes (6): AdvancedDrawerController, advancedDrawerController, build, HomeView, routeName, package:mind_feed/features/home/presentation/widgets/home_view_body.dart

### Community 85 - "check_code_view_body.dart"
Cohesion: 0.08
Nodes (25): dart:async, _authSubscription, autovalidateMode, build, CheckCodeViewBody, _CheckCodeViewBodyState, _codeController, _cooldownTimer (+17 more)

### Community 86 - "Exception"
Cohesion: 0.60
Nodes (4): Exception?, CacheException, NoInternetException, ServerException

### Community 87 - "login_params.dart"
Cohesion: 0.40
Nodes (4): email, LoginParams, password, toJson

### Community 88 - "downloaded_article_entity.dart"
Cohesion: 0.08
Nodes (24): DateTime, authorAvatar, authorName, authorRole, categoryId, categorySlug, content, copyWith (+16 more)

### Community 90 - "save_favorite_categories_use_case.dart"
Cohesion: 0.11
Nodes (17): ProfileRepoImpl, getCategories, getFavoriteCategories, getProfile, ProfileRepository, reconcilePendingCategorySync, saveLocalCategories, syncFavoriteCategories (+9 more)

### Community 92 - "3. Monolithic Files Exceeding 250 Lines"
Cohesion: 0.08
Nodes (24): 1. Executive Summary, 2.1 Transport Leaks in Domain Layer, 2.2 Shallow Modules (1-Line Use Case Indirections), 2.3 Dead Injections & Misleading Seams, 2.4 False Semantics in Local Cache DataSource, 2.5 Global Mutable State Leaking Cross-Feature, 2.6 Dual Conflicting Cache Implementations, 2. Architectural Seams & Layering Violations (+16 more)

### Community 93 - "articles_remote_data_source.dart"
Cohesion: 0.08
Nodes (23): _client, deleteArticle, getArticleById, getArticlesByAuthor, getArticlesByCategory, getCategories, getFixedTags, getHomeFeed (+15 more)

### Community 94 - "articles_repo_impl.dart"
Cohesion: 0.08
Nodes (23): clearDownloadedArticles, deleteArticle, getArticleById, getArticlesByAuthor, getArticlesByCategory, getCategories, getFixedTags, getHomeFeed (+15 more)

### Community 95 - "cache_helper.dart"
Cohesion: 0.13
Nodes (14): Box, box, clearData, containsKey, getData, getDataFromHive, getDataString, kBoxName (+6 more)

### Community 96 - "articles_repo.dart"
Cohesion: 0.10
Nodes (19): clearDownloadedArticles, deleteArticle, getArticleById, getArticlesByAuthor, getArticlesByCategory, getCategories, getFixedTags, getHomeFeed (+11 more)

### Community 97 - "2. Technical Implementation Boundaries"
Cohesion: 0.11
Nodes (17): 1. Critical Schema & Architectural Reconciliations, 2.1 Feed Ranking & Category Prioritization, 2.2 Content & Image Validation, 2.3 Search, Filtering & Pagination, 2.4 Star & Bookmark Separation, 2.5 Offline Text-Only Storage (BR-04, BR-06), 2.6 Immutability & Deletion Retention, 2. Technical Implementation Boundaries (+9 more)

### Community 98 - "auth_api_source.dart"
Cohesion: 0.13
Nodes (14): authConfirmRedirectUrl, _client, currentUser, login, onAuthStateChange, resendOtp, resetPassword, signInWithGoogle (+6 more)

### Community 99 - "categories_view.dart"
Cohesion: 0.09
Nodes (22): @HiveType, fromEntity, fromJson, toJson, toUserEntity, UserModel, UserEntity, build (+14 more)

### Community 100 - "home_view_body.dart"
Cohesion: 0.18
Nodes (11): _breathingAnimation, _breathingController, createState, dispose, _fetchRealStories, HomeViewBody, _HomeViewBodyState, initState (+3 more)

### Community 101 - "settings_cubit.dart"
Cohesion: 0.21
Nodes (12): cachedMegabytes, copyWith, dataPreservation, SettingsInitial, SettingsLoaded, SettingsState, wifiOnly, clearCache (+4 more)

### Community 102 - "article_model.dart"
Cohesion: 0.22
Nodes (8): ArticleModel, copyWith, fromEntity, fromJson, _parseDateTime, _parseTags, toJson, ArticleEntity

### Community 103 - "List"
Cohesion: 0.11
Nodes (18): StringExtension, accessToken, email, hasActiveSession, props, userId, description, id (+10 more)

### Community 104 - "password_text_field.dart"
Cohesion: 0.18
Nodes (11): FocusNode, build, controller, createState, dispose, hintText, _isObscured, onChanged (+3 more)

### Community 105 - "MindFeed Phase 1 — Database Baseline & Migration Reconciliation Verification Report"
Cohesion: 0.17
Nodes (11): 1. Executive Summary, 2.1 Baseline Migration: `supabase/migrations/20261015000000_baseline_schema.sql`, 2.2 Catalog Seed Migration: `supabase/migrations/20261015000001_seed_catalog.sql`, 2.3 Supabase Configuration & Supplemental Seeds, 2. Deliverables Inventory in Version Control, 3. Local Clean Database Verification Results, 4.1 Migration History Tracking, 4.2 Live Data Preservation Audit (+3 more)

### Community 106 - "MindFeed Phase 1 — Database Baseline and Migration Reconciliation Report"
Cohesion: 0.18
Nodes (10): 1. Executive Summary, 2.1 Baseline Migration, 2.2 Seed Migrations & Local Seed Files, 2.3 Production Editorial Articles Backup, 2. Deliverables Inventory, 3. Live Database Verification and Integrity Evidence, 4. Migration History Reconciliation Evidence, 5. Phase 1 Completion & Next Steps (+2 more)

### Community 107 - "app_images.dart"
Cohesion: 0.14
Nodes (13): Assets, assetsImagesBusinessIcon, assetsImagesEducationIcon, assetsImagesJustTest, assetsImagesMindFeedLogo, assetsImagesMITNewsAICoding, assetsImagesOnBoarding1, assetsImagesOnBoarding2 (+5 more)

### Community 108 - "Equatable"
Cohesion: 0.22
Nodes (8): Equatable, AuthResultEntity, CategoryModel, fromEntity, fromJson, toJson, CategoryEntity, package:mind_feed/features/home/domain/entities/category_entity.dart

### Community 109 - "logout_use_case.dart"
Cohesion: 0.33
Nodes (5): articlesRepo, authRepo, call, localDataSource, LogoutUseCase

### Community 110 - "change_password_form.dart"
Cohesion: 0.18
Nodes (11): autovalidateMode, build, ChangePasswordForm, _ChangePasswordFormState, confirmPassword, createState, email, formKey (+3 more)

### Community 111 - "_EditorialCardStackState"
Cohesion: 0.67
Nodes (3): EditorialCardStack, _EditorialCardStackState, SingleTickerProviderStateMixin

### Community 112 - "failures.dart"
Cohesion: 0.43
Nodes (6): CacheFailure, Failure, message, props, ServerFailure, ValidationFailure

### Community 113 - "article_card_of_author.dart"
Cohesion: 0.29
Nodes (6): ArticleCardOfAuthor, build, imagePath, isDwonload, isFav, title

### Community 114 - "list_saved_articles.dart"
Cohesion: 0.20
Nodes (8): build, ListSavedArticles, routeName, ArticlesCategoryView, build, routeName, package:mind_feed/features/collections/presentation/views/articles_saved.dart, static const

### Community 115 - "widget_test.dart"
Cohesion: 0.29
Nodes (6): package:mind_feed/features/home/presentation/views/article_view.dart, package:mind_feed/features/main/presentation/views/main_view.dart, package:mind_feed/features/main/presentation/widgets/main_navigation_bar.dart, package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart, editorialHarness, main

### Community 116 - "page_view_item.dart"
Cohesion: 0.33
Nodes (5): build, description, PageViewItem, title, package:google_fonts/google_fonts.dart

### Community 117 - "custom_popup_menu_button_for_article_view.dart"
Cohesion: 0.17
Nodes (9): build, CustomPopupMenuButtonForSavedArticlesView, build, CustomPopupMenuButtonForHomeView, isDwonload, build, CustomPopupMenuButtonForArticleView, isDwonload (+1 more)

### Community 118 - "article_card.dart"
Cohesion: 0.17
Nodes (11): ArticleCard, author, date, imagePath, isDwonload, isFav, title, package:mind_feed/features/home/presentation/widgets/add_to_favorite_article_card.dart (+3 more)

### Community 119 - "main_navigation_bar.dart"
Cohesion: 0.18
Nodes (10): IconData, active, build, icon, label, MainNavigationBar, _Nav, onDestinationSelected (+2 more)

### Community 120 - "search_bar.dart"
Cohesion: 0.22
Nodes (8): build, controller, CustomSearchBar, hintText, onChanged, semanticLabel, trailingSearchIcon, TextEditingController

### Community 121 - "State"
Cohesion: 0.14
Nodes (19): LoginForm, _LoginFormState, SendCodeViewBody, _SendCodeViewBodyState, AuthorView, _AuthorViewState, _ArticlesSavedContent, _ArticlesSavedContentState (+11 more)

### Community 122 - "tag_model.dart"
Cohesion: 0.29
Nodes (6): fromEntity, fromJson, TagModel, toJson, TagEntity, package:mind_feed/features/home/domain/entities/tag_entity.dart

### Community 123 - "categories_view_test.dart"
Cohesion: 0.11
Nodes (16): Map, package:flutter_test/flutter_test.dart, package:mind_feed/core/design/editorial_card_stack.dart, package:mind_feed/core/design/editorial_saved_stack.dart, package:mind_feed/features/auth/presentation/views/categories_view.dart, harness, main, testItems (+8 more)

### Community 124 - "email_text_field.dart"
Cohesion: 0.29
Nodes (6): build, controller, EmailTextField, onChanged, package:mind_feed/core/widgets/custom_text_field.dart, ValueChanged

### Community 125 - "change_password_view.dart"
Cohesion: 0.33
Nodes (5): build, ChangePasswordView, email, routeName, package:mind_feed/features/auth/presentation/widgets/change_password_view_body.dart

### Community 127 - "build"
Cohesion: 0.40
Nodes (5): build, build, build, AppRoutes.article, AppRoutes.profile

### Community 128 - "package:mind_feed/core/networking/api_result.dart"
Cohesion: 0.06
Nodes (39): call, repo, ResendOtpUseCase, ArticlesRepositoryImpl, ArticlesRepository, call, DeleteArticleUseCase, repo (+31 more)

### Community 130 - "check_code_view.dart"
Cohesion: 0.33
Nodes (5): build, CheckCodeView, email, routeName, package:mind_feed/features/auth/presentation/widgets/check_code_view_body.dart

### Community 131 - "ArticlesRemoteDataSource"
Cohesion: 0.67
Nodes (3): ArticlesRemoteDataSource, ArticlesRemoteDataSourceImpl, FakeArticlesRemoteDataSource

### Community 132 - "static const String"
Cohesion: 0.33
Nodes (5): build, routeName, SendCodeView, package:mind_feed/features/auth/presentation/widgets/send_code_view_body.dart, static const String

### Community 133 - "Cubit"
Cohesion: 0.60
Nodes (4): SearchInitial, SearchState, Cubit, SearchCubit

### Community 134 - "AppRoutes.checkCode"
Cohesion: 0.50
Nodes (4): build, build, build, AppRoutes.checkCode

## Knowledge Gaps
- **1414 isolated node(s):** `capitalize`, `reversed`, `toInt`, `toDouble`, `toNum` (+1409 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1598 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `UserEntity` connect `categories_view.dart` to `category_onboarding_clean_architecture_test.dart`, `main.dart`, `user_entity.dart`, `category_sync_hardening_test.dart`, `auth_repo_impl.dart`, `offline_articles_and_logout_test.dart`, `check_code_view_body.dart`, `profile_repo_impl.dart`, `cache_helper.dart`?**
  _High betweenness centrality (0.014) - this node is a cross-community bridge._
- **Why does `SignupCubit` connect `signup_cubit.dart` to `sign_up_form_body.dart`, `Cubit`, `duplicate_signup_test.dart`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Why does `ArticlesRepository` connect `package:mind_feed/core/networking/api_result.dart` to `articles_repo.dart`, `setup_service_locator.dart`, `user_articles.dart`, `logout_use_case.dart`, `profile_repo_impl.dart`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._
- **What connects `capitalize`, `reversed`, `toInt` to the rest of the system?**
  _1414 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.01652892561983471 - nodes in this community are weakly interconnected._
- **Should `app_icons.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.02666666666666667 - nodes in this community are weakly interconnected._
- **Should `category_onboarding_clean_architecture_test.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.07459677419354839 - nodes in this community are weakly interconnected._