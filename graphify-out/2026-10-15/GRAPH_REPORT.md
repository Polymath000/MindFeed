# Graph Report - MindFeed-main  (2026-10-15)

## Corpus Check
- 225 files · ~255,432 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2220 nodes · 3277 edges · 133 communities (128 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `8a20febf`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- app_colors.dart
- app_icons.dart
- category_onboarding_clean_architecture_test.dart
- app_text_styles.dart
- add_article_cubit.dart
- editorial_card_stack.dart
- home_of_add_article_view.dart
- custom_text_field.dart
- app_routes.dart
- package:mind_feed/config/routes/app_routes.dart
- app_theme_data.dart
- category_sync_hardening_test.dart
- collections_cubit.dart
- markdown_text_input.dart
- Business Requirements Document (BRD)
- StatelessWidget
- profile_view_body.dart
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
- package:mind_feed/core/constants/borders.dart
- AuthRepository
- device_preference_notifier.dart
- list_card.dart
- borders.dart
- theme_config.dart
- format_markdown.dart
- MindFeed Editorial UI Specification & Architecture
- package:mind_feed/core/constants/app_icons.dart
- next_button.dart
- settings_view_body.dart
- Mind Feed
- article_entity.dart
- sign_up_form_body.dart
- onboarding_view_body.dart
- email_confirmation_and_auth_flow_test.dart
- custom_app_bar.dart
- change_password_form.dart
- auth_api_source.dart
- constants.dart
- categories_cubit.dart
- category_card.dart
- custom_drawer.dart
- Fake
- package:flutter_bloc/flutter_bloc.dart
- theme_mode_cubit.dart
- editorial_card.dart
- editorial_saved_stack.dart
- shared_preferences_singleton.dart
- login_form.dart
- main_view.dart
- article_view.dart
- MindFeed Editorial UI Transformation Plan
- Hermes Review Result: S1-editorial-shell
- string_extension.dart
- MindFeed Phase 0 — Repository and Live Database Reconciliation Report
- articles_saved.dart
- package:mind_feed/features/home/domain/entities/article_entity.dart
- home_view.dart
- package:flutter/foundation.dart
- Orchestration State
- package:mind_feed/core/utls/setup_service_locator.dart
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
- change_password_view.dart
- check_code_view_body.dart
- Exception
- login_params.dart
- downloaded_article_entity.dart
- main_navigation_bar.dart
- 3. Monolithic Files Exceeding 250 Lines
- articles_remote_data_source.dart
- articles_repo_impl.dart
- cache_helper.dart
- articles_repo.dart
- 2. Technical Implementation Boundaries
- setup_service_locator.dart
- package:mind_feed/features/auth/domain/entities/user_entity.dart
- home_view_body.dart
- settings_cubit.dart
- article_model.dart
- List
- categories_view.dart
- MindFeed Phase 1 — Database Baseline & Migration Reconciliation Verification Report
- MindFeed Phase 1 — Database Baseline and Migration Reconciliation Report
- static const String
- get_categories_use_case.dart
- password_text_field.dart
- profile_repo.dart
- @immutable
- failures.dart
- article_card.dart
- app_images.dart
- MarkdownTextInput
- page_view_item.dart
- Cubit
- categories_view_body.dart
- Equatable
- logout_use_case.dart
- add_to_favorite_article_card.dart
- category_entity.dart
- categories_view_test.dart
- tag_model.dart
- publish_article_use_case.dart
- build
- package:mind_feed/core/networking/api_result.dart
- _EditorialCardStackState
- ArticlesRemoteDataSource
- State

## God Nodes (most connected - your core abstractions)
1. `Continuation Packet: S1-editorial-shell-recovery` - 19 edges
2. `Task Packet: S1-editorial-shell` - 18 edges
3. `Task Packet: S2-auth-refinement` - 18 edges
4. `ArticlesRepository` - 17 edges
5. `Mini-requirements` - 16 edges
6. `UserEntity` - 13 edges
7. `SignupCubit` - 13 edges
8. `AddArticleCubit` - 12 edges
9. `AuthRepository` - 11 edges
10. `CategoriesCubit` - 11 edges

## Surprising Connections (you probably didn't know these)
- `MockNetworkInfo` --implements--> `NetworkInfo`  [EXTRACTED]
  test/features/home/article_data_and_domain_test.dart → lib/core/networking/network_info.dart
- `FakeNetworkInfo` --implements--> `NetworkInfo`  [EXTRACTED]
  test/offline_articles_and_logout_test.dart → lib/core/networking/network_info.dart
- `FakeArticlesRemoteDataSource` --implements--> `ArticlesRemoteDataSource`  [EXTRACTED]
  test/features/home/article_data_and_domain_test.dart → lib/features/home/data/datasources/articles_remote_data_source.dart
- `FakeArticlesLocalDataSource` --implements--> `ArticlesLocalDataSource`  [EXTRACTED]
  test/offline_articles_and_logout_test.dart → lib/features/home/domain/repos/articles_local_data_source.dart
- `FakeNetworkInfo` --implements--> `NetworkInfo`  [EXTRACTED]
  test/features/auth/email_confirmation_and_auth_flow_test.dart → lib/core/networking/network_info.dart

## Import Cycles
- None detected.

## Communities (133 total, 1 thin omitted)

### Community 0 - "app_colors.dart"
Cohesion: 0.02
Nodes (120): almostBlack, amber, amberDark, amberDarker, black, blue, blueMain, blush (+112 more)

### Community 1 - "app_icons.dart"
Cohesion: 0.03
Nodes (74): add, alternateEmailRounded, AppIcons, arrowBackRounded, arrowForwardIosRounded, articleOutlined, boltRounded, bookmark (+66 more)

### Community 2 - "category_onboarding_clean_architecture_test.dart"
Cohesion: 0.08
Nodes (24): PostgrestException, SupabaseQueryBuilder, categoriesList, clearDownloadedArticles, clearOfflineCalled, FakeSupabaseQueryBuilder, from, fromInvoked (+16 more)

### Community 3 - "app_text_styles.dart"
Cohesion: 0.09
Nodes (21): bodyLarge, bodyMedium, bodySmall, displayLarge, displayMedium, displaySmall, headlineLarge, headlineMedium (+13 more)

### Community 4 - "add_article_cubit.dart"
Cohesion: 0.16
Nodes (18): AddArticleError, AddArticleFileLoaded, AddArticleInitial, AddArticleLoading, AddArticleState, content, fileName, message (+10 more)

### Community 5 - "editorial_card_stack.dart"
Cohesion: 0.10
Nodes (20): _animController, build, _cards, createState, didUpdateWidget, dispose, _dragOffset, height (+12 more)

### Community 6 - "home_of_add_article_view.dart"
Cohesion: 0.09
Nodes (22): build, createState, devicePreferenceNotifier, dispose, _fullView, _getFileContents, Home, _HomeState (+14 more)

### Community 7 - "custom_text_field.dart"
Cohesion: 0.08
Nodes (25): build, CustomTextField, hintText, keyboardType, obscureText, onChanged, prefixIcon, suffixIcon (+17 more)

### Community 8 - "app_routes.dart"
Cohesion: 0.06
Nodes (34): addArticle, AppRoutes, article, articlesCategory, articlesSaved, author, categories, changePassword (+26 more)

### Community 9 - "package:mind_feed/config/routes/app_routes.dart"
Cohesion: 0.15
Nodes (15): build, LoginViewBody, build, build, package:mind_feed/config/routes/app_routes.dart, package:mind_feed/core/helpers/custom_show_snack_bar.dart, package:mind_feed/core/widgets/custom_loading_indecator.dart, package:mind_feed/features/auth/presentation/controllers/login_cubit/login_cubit.dart (+7 more)

### Community 10 - "app_theme_data.dart"
Cohesion: 0.06
Nodes (34): card, checkbox, chip, dialog, dropdownMenu, filledButton, floatingActionButton, iconButton (+26 more)

### Community 11 - "category_sync_hardening_test.dart"
Cohesion: 0.11
Nodes (17): Directory, MockProfileRemoteDataSource, package:mind_feed/features/auth/domain/usecases/logout_use_case.dart, package:mind_feed/features/home/data/datasources/articles_local_data_source.dart, categoriesList, clearAllDownloadedArticles, cleared, getCategories (+9 more)

### Community 12 - "collections_cubit.dart"
Cohesion: 0.23
Nodes (12): CollectionsInitial, CollectionsLoaded, CollectionsLoading, CollectionsState, stories, _allStories, CollectionsCubit, deleteArticle (+4 more)

### Community 13 - "markdown_text_input.dart"
Cohesion: 0.07
Nodes (26): Function, int?, actions, actionWidget, _basicInkwell, build, controller, _controllerListener (+18 more)

### Community 14 - "Business Requirements Document (BRD)"
Cohesion: 0.08
Nodes (24): 1.1 Purpose, 1.2 Business Problem Statement, 1.3 Vision & Solution, 1. Executive Summary, 2. Business Objectives & Key Performance Indicators (KPIs), 3.1 Competitive Landscape, 3.2 Target Audience Segments, 3. Market Analysis & Value Proposition (+16 more)

### Community 15 - "StatelessWidget"
Cohesion: 0.10
Nodes (23): build, buildSettingsMenuItem, buildSettingsMenuItemSwitcher, buildSettingsMenuItemWithDropMenu, children, icon, kicker, onChanged (+15 more)

### Community 16 - "profile_view_body.dart"
Cohesion: 0.33
Nodes (5): build, ProfileViewBody, package:mind_feed/features/profile/presentation/widget/personal_infromation.dart, package:mind_feed/features/profile/presentation/widget/profile_app_bar.dart, package:mind_feed/features/profile/presentation/widget/user_articles.dart

### Community 17 - "auth_repo_impl.dart"
Cohesion: 0.09
Nodes (23): dart:convert, CacheHelper, cacheHelper, getUser, key, UserCacheDataSource, authApiSource, cacheHelper (+15 more)

### Community 18 - "package:flutter/material.dart"
Cohesion: 0.08
Nodes (18): customShowSnackBar, duration, build, CustomLoadingIndecator, authBackground, build, SignUpForm, build (+10 more)

### Community 19 - "Mini-requirements"
Cohesion: 0.09
Nodes (21): 1. Mandatory Authentication & Onboarding, 2. Home Feed & Discovery, 3. Article Reader, Starring & Sharing, 4. Offline Mode (Text-Only), 5. Article Drafting, Preview, Publishing & Lifecycle, 6. Personal Collections & Settings, Acceptance Criteria, Business Rules (+13 more)

### Community 20 - "Continuation Packet: S1-editorial-shell-recovery"
Cohesion: 0.10
Nodes (19): Allowed edit scope, Areas that must not be redesigned, Completed work, Continuation objective, Continuation Packet: S1-editorial-shell-recovery, Current failures, Exact files to inspect, Exact remaining work (+11 more)

### Community 21 - "package:mind_feed/core/constants/app_colors.dart"
Cohesion: 0.07
Nodes (21): build, ForgetPasswordText, build, CustombackgroundForTheDrawerInHomePage, build, OnboardingView, routeName, build (+13 more)

### Community 22 - "package:mind_feed/core/constants/app_text_styles.dart"
Cohesion: 0.10
Nodes (16): ArticleCardInformation, author, build, date, title, author, build, date (+8 more)

### Community 23 - "package:mind_feed/core/constants/app_images.dart"
Cohesion: 0.10
Nodes (16): build, Logo, build, DownloadedArticlesViewBody, build, FavoriteMoviesViewBody, ArticleViewBody, build (+8 more)

### Community 24 - "Task Packet: S1-editorial-shell"
Cohesion: 0.11
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 25 - "Task Packet: S2-auth-refinement"
Cohesion: 0.11
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 26 - "NetworkInfo"
Cohesion: 0.20
Nodes (10): Connectivity, Future, connectivity, isConnected, NetworkInfo, NetworkInfoImpl, package:connectivity_plus/connectivity_plus.dart, FakeNetworkInfo (+2 more)

### Community 27 - "profile_repo_impl.dart"
Cohesion: 0.13
Nodes (14): getCategories, getFavoriteCategories, getProfile, reconcilePendingCategorySync, remoteDataSource, saveLocalCategories, syncFavoriteCategories, updateProfile (+6 more)

### Community 28 - "editorial_design.dart"
Cohesion: 0.12
Nodes (17): authorName, build, _buildShareAction, createState, EditorialFollowButton, _EditorialFollowButtonState, EditorialIconButton, icon (+9 more)

### Community 29 - "package:mind_feed/core/constants/borders.dart"
Cohesion: 0.10
Nodes (16): build, buttonText, CustomButton, height, build, _buildRequirementRow, password, PasswordRequirements (+8 more)

### Community 30 - "AuthRepository"
Cohesion: 0.12
Nodes (16): AuthRepoImpl, AuthRepository, call, LoginUseCase, repo, call, repo, ResendOtpUseCase (+8 more)

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
Cohesion: 0.15
Nodes (12): dart:math, convertToMarkdown, cursorIndex, data, FormatMarkdown, image, MarkdownType, replaceCursorIndex (+4 more)

### Community 36 - "MindFeed Editorial UI Specification & Architecture"
Cohesion: 0.13
Nodes (14): 1. Visual Design Language (`lib/core/design/editorial_design.dart`), 2. Reusable Modular Components, 3. Screen Implementations, 4. Documentation & Verification Assets, 5. Automated Tests, Card Component (`lib/core/design/editorial_card.dart`), Data Models & Repository (`lib/core/design/editorial_models.dart`, `editorial_mock_data.dart`), Floating Editorial Navigation (`lib/features/main/presentation/widgets/main_navigation_bar.dart`) (+6 more)

### Community 37 - "package:mind_feed/core/constants/app_icons.dart"
Cohesion: 0.06
Nodes (30): build, MoreVertIcon, build, ChangePasswordViewBody, email, AuthorPersonalInfo, build, _buildStatItem (+22 more)

### Community 38 - "next_button.dart"
Cohesion: 0.13
Nodes (12): build, currentPage, NextButton, pageController, build, OnBoardingBackground, pageController, build (+4 more)

### Community 39 - "settings_view_body.dart"
Cohesion: 0.13
Nodes (15): _bionicGuide, _breakingAlerts, build, _cachedMegabytes, createState, _dataPreservation, _fontScale, _morningBriefing (+7 more)

### Community 40 - "Mind Feed"
Cohesion: 0.14
Nodes (13): Architecture, Building APK, Features, Getting Started, Installation, Key Dependencies, License, Mind Feed (+5 more)

### Community 41 - "article_entity.dart"
Cohesion: 0.06
Nodes (35): authorAvatar, authorId, authorName, authorRole, badge, badgeColor, cardColor, categoryId (+27 more)

### Community 42 - "sign_up_form_body.dart"
Cohesion: 0.17
Nodes (11): autovalidateMode, build, _confirmPasswordController, createState, dispose, _emailController, formKey, initState (+3 more)

### Community 43 - "onboarding_view_body.dart"
Cohesion: 0.17
Nodes (12): build, createState, _currentPage, dispose, initState, OnboardingViewBody, _OnboardingViewBodyState, _pageController (+4 more)

### Community 44 - "email_confirmation_and_auth_flow_test.dart"
Cohesion: 0.08
Nodes (29): ../errors/failures.dart, FakeNetworkInfo, HttpOverrides, ApiResult, data, failure, FailureResult, Success (+21 more)

### Community 45 - "custom_app_bar.dart"
Cohesion: 0.12
Nodes (17): AdvancedDrawerValue, build, CustomAppBar, _handleMenuButtonPressed, title, build, DownloadedArticlesView, routeName (+9 more)

### Community 46 - "change_password_form.dart"
Cohesion: 0.18
Nodes (10): autovalidateMode, build, confirmPassword, createState, email, formKey, password, package:mind_feed/core/widgets/custom_button.dart (+2 more)

### Community 47 - "auth_api_source.dart"
Cohesion: 0.05
Nodes (50): email, errorMessage, isUserAlreadyRegistered, SignupFailure, SignupInitial, SignupLoading, SignupRequiresConfirmation, SignupState (+42 more)

### Community 48 - "constants.dart"
Cohesion: 0.17
Nodes (11): AppConstants, appName, compact, page, roomy, supabaseAnonKey, supabaseUrl, themeModeKey (+3 more)

### Community 49 - "categories_cubit.dart"
Cohesion: 0.22
Nodes (14): CategoriesFailure, CategoriesInitial, CategoriesLoading, CategoriesSelectionChanged, CategoriesState, CategoriesSuccess, errorMessage, CategoriesCubit (+6 more)

### Community 50 - "category_card.dart"
Cohesion: 0.09
Nodes (20): actionText, AuthPromptLink, build, onTap, promptText, build, category, CategoryCard (+12 more)

### Community 51 - "custom_drawer.dart"
Cohesion: 0.17
Nodes (11): build, CustomDrawer, routeName, build, package:flutter_svg/flutter_svg.dart, package:mind_feed/features/collections/presentation/views/downloaded_articles_view.dart, package:mind_feed/features/collections/presentation/views/favorite_movies_view.dart, package:mind_feed/features/settings/presentation/views/settings_view.dart (+3 more)

### Community 52 - "Fake"
Cohesion: 0.11
Nodes (21): Fake, AuthApiSource, _client, getCategories, getFavoriteCategories, getProfile, ProfileRemoteDataSource, ProfileRemoteDataSourceImpl (+13 more)

### Community 53 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.16
Nodes (17): email, errorMessage, LoginFailure, LoginInitial, LoginLoading, LoginState, LoginSuccess, eitherFailureOrLogin (+9 more)

### Community 54 - "theme_mode_cubit.dart"
Cohesion: 0.22
Nodes (13): ThemeModeDark, ThemeModeInitial, ThemeModeLight, ThemeModeState, ThemeModeSystem, changeThemeMode, getThemeMode, ThemeModeCubit (+5 more)

### Community 55 - "editorial_card.dart"
Cohesion: 0.14
Nodes (12): build, EditorialCard, item, onLike, onOpen, onSave, onShare, showActions (+4 more)

### Community 56 - "editorial_saved_stack.dart"
Cohesion: 0.17
Nodes (12): build, _buildDismissibleCard, createState, _deleteItem, didUpdateWidget, EditorialSavedStack, _EditorialSavedStackState, initState (+4 more)

### Community 57 - "shared_preferences_singleton.dart"
Cohesion: 0.17
Nodes (11): clear, getBool, getKeys, getString, init, _instance, remove, setBool (+3 more)

### Community 58 - "login_form.dart"
Cohesion: 0.13
Nodes (16): AutovalidateMode, FormState, GlobalKey, autovalidateMode, build, createState, email, formKey (+8 more)

### Community 59 - "main_view.dart"
Cohesion: 0.11
Nodes (17): build, ListSavedArticles, routeName, build, createState, initState, routeName, selectedIndex (+9 more)

### Community 60 - "article_view.dart"
Cohesion: 0.14
Nodes (14): ToggleBookmarkUseCase, _article, ArticleView, _ArticleViewState, build, createState, initState, _isLiked (+6 more)

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

### Community 65 - "articles_saved.dart"
Cohesion: 0.15
Nodes (11): ArticlesSaved, build, createState, dispose, routeName, _searchController, build, routeName (+3 more)

### Community 66 - "package:mind_feed/features/home/domain/entities/article_entity.dart"
Cohesion: 0.15
Nodes (10): call, GetArticleDetailsUseCase, repo, call, GetArticlesByCategoryUseCase, repo, call, repo (+2 more)

### Community 67 - "home_view.dart"
Cohesion: 0.29
Nodes (6): AdvancedDrawerController, advancedDrawerController, build, HomeView, routeName, package:mind_feed/features/home/presentation/widgets/home_view_body.dart

### Community 68 - "package:flutter/foundation.dart"
Cohesion: 0.25
Nodes (7): Client, http.BaseClient, _inner, send, SupabaseInterceptor, package:flutter/foundation.dart, package:http/http.dart

### Community 69 - "Orchestration State"
Cohesion: 0.25
Nodes (7): Active file leases, Blockers and decisions, Last verified checkpoint, Milestones, Orchestration State, Project, Stage tracker

### Community 70 - "package:mind_feed/core/utls/setup_service_locator.dart"
Cohesion: 0.15
Nodes (11): MethodChannel, package:flutter_test/flutter_test.dart, package:mind_feed/core/design/editorial_card_stack.dart, package:mind_feed/core/design/editorial_saved_stack.dart, package:mind_feed/core/networking/network_info.dart, package:mind_feed/core/utls/setup_service_locator.dart, harness, main (+3 more)

### Community 71 - "main.dart"
Cohesion: 0.22
Nodes (8): globalDevicePreferenceNotifier, init, initFlutter, loadDevicePreferences, main, package:flutter/services.dart, package:mind_feed/core/networking/supabase_interceptor.dart, package:mind_feed/main_app.dart

### Community 72 - "signup_params.dart"
Cohesion: 0.25
Nodes (7): displayName, email, password, SignupParams, toJson, toSignUpJson, toUpdateDisplayNameJson

### Community 73 - "add_article.dart"
Cohesion: 0.25
Nodes (7): AddArticleView, build, MarkdownEditorApp, routeName, package:mind_feed/features/add_article/presentation/views/home_of_add_article_view.dart, package:mind_feed/features/add_article/presentation/widget/device_preference_notifier.dart, package:mind_feed/main.dart

### Community 74 - "user_entity.dart"
Cohesion: 0.22
Nodes (8): StringExtension, copyWith, email, favoriteCategories, token, userName, package:hive_flutter/adapters.dart, String?

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
Cohesion: 0.18
Nodes (11): _authorStories, AuthorView, _AuthorViewState, build, createState, initState, _loadAuthorStories, routeName (+3 more)

### Community 80 - "datasources/articles_local_data_source.dart"
Cohesion: 0.07
Nodes (29): ArticlesLocalDataSourceImpl, _box, boxName, clearAllDownloadedArticles, deleteDownloadedArticle, getDownloadedArticleById, getDownloadedArticles, _openBox (+21 more)

### Community 81 - "Project Context: Mind Feed"
Cohesion: 0.33
Nodes (5): 1. Overview, 2. Architecture & Directory Structure, 3. Technology Stack & Key Libraries, 4. Recent Project Changes, Project Context: Mind Feed

### Community 82 - "offline_articles_and_logout_test.dart"
Cohesion: 0.10
Nodes (20): GoTrueClient, GoTrueClient get, package:mind_feed/features/home/domain/usecases/delete_downloaded_article_use_case.dart, async, auth, authClient, clearAllCalled, clearAllDownloadedArticles (+12 more)

### Community 83 - "package:supabase_flutter/supabase_flutter.dart"
Cohesion: 0.25
Nodes (7): ../errors/exceptions.dart, ApiErrorHandler, code, handle, message, toFailure, package:supabase_flutter/supabase_flutter.dart

### Community 84 - "change_password_view.dart"
Cohesion: 0.33
Nodes (5): build, ChangePasswordView, email, routeName, package:mind_feed/features/auth/presentation/widgets/change_password_view_body.dart

### Community 85 - "check_code_view_body.dart"
Cohesion: 0.08
Nodes (23): dart:async, _authSubscription, autovalidateMode, build, _codeController, _cooldownTimer, createState, dispose (+15 more)

### Community 86 - "Exception"
Cohesion: 0.60
Nodes (4): Exception?, CacheException, NoInternetException, ServerException

### Community 87 - "login_params.dart"
Cohesion: 0.40
Nodes (4): email, LoginParams, password, toJson

### Community 88 - "downloaded_article_entity.dart"
Cohesion: 0.08
Nodes (24): DateTime, authorAvatar, authorName, authorRole, categoryId, categorySlug, content, copyWith (+16 more)

### Community 90 - "main_navigation_bar.dart"
Cohesion: 0.18
Nodes (10): IconData, active, build, icon, label, MainNavigationBar, _Nav, onDestinationSelected (+2 more)

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

### Community 98 - "setup_service_locator.dart"
Cohesion: 0.10
Nodes (23): getIt, setupServiceLocator, ProfileRepoImpl, CategorySyncReconciler, _profileRepository, reconcilePendingSync, ProfileRepository, call (+15 more)

### Community 99 - "package:mind_feed/features/auth/domain/entities/user_entity.dart"
Cohesion: 0.22
Nodes (8): @HiveType, fromEntity, fromJson, toJson, toUserEntity, UserModel, UserEntity, package:mind_feed/features/auth/domain/entities/user_entity.dart

### Community 100 - "home_view_body.dart"
Cohesion: 0.15
Nodes (13): Animation, AnimationController, _breathingAnimation, _breathingController, createState, dispose, _fetchRealStories, HomeViewBody (+5 more)

### Community 101 - "settings_cubit.dart"
Cohesion: 0.21
Nodes (12): cachedMegabytes, copyWith, dataPreservation, SettingsInitial, SettingsLoaded, SettingsState, wifiOnly, clearCache (+4 more)

### Community 102 - "article_model.dart"
Cohesion: 0.29
Nodes (6): copyWith, fromEntity, fromJson, _parseDateTime, _parseTags, toJson

### Community 103 - "List"
Cohesion: 0.17
Nodes (11): accessToken, email, hasActiveSession, props, userId, id, name, props (+3 more)

### Community 104 - "categories_view.dart"
Cohesion: 0.22
Nodes (8): build, _buildCubit, categoriesCubit, CategoriesView, profileRemoteDataSource, routeName, userEntity, package:mind_feed/features/profile/domain/usecases/save_favorite_categories_use_case.dart

### Community 105 - "MindFeed Phase 1 — Database Baseline & Migration Reconciliation Verification Report"
Cohesion: 0.17
Nodes (11): 1. Executive Summary, 2.1 Baseline Migration: `supabase/migrations/20261015000000_baseline_schema.sql`, 2.2 Catalog Seed Migration: `supabase/migrations/20261015000001_seed_catalog.sql`, 2.3 Supabase Configuration & Supplemental Seeds, 2. Deliverables Inventory in Version Control, 3. Local Clean Database Verification Results, 4.1 Migration History Tracking, 4.2 Live Data Preservation Audit (+3 more)

### Community 106 - "MindFeed Phase 1 — Database Baseline and Migration Reconciliation Report"
Cohesion: 0.18
Nodes (10): 1. Executive Summary, 2.1 Baseline Migration, 2.2 Seed Migrations & Local Seed Files, 2.3 Production Editorial Articles Backup, 2. Deliverables Inventory, 3. Live Database Verification and Integrity Evidence, 4. Migration History Reconciliation Evidence, 5. Phase 1 Completion & Next Steps (+2 more)

### Community 107 - "static const String"
Cohesion: 0.17
Nodes (10): build, CheckCodeView, email, routeName, build, routeName, SendCodeView, package:mind_feed/features/auth/presentation/widgets/check_code_view_body.dart (+2 more)

### Community 108 - "get_categories_use_case.dart"
Cohesion: 0.22
Nodes (7): fromEntity, fromJson, toJson, call, GetCategoriesUseCase, repo, package:mind_feed/features/home/domain/entities/category_entity.dart

### Community 109 - "password_text_field.dart"
Cohesion: 0.18
Nodes (11): FocusNode, build, controller, createState, dispose, hintText, _isObscured, onChanged (+3 more)

### Community 110 - "profile_repo.dart"
Cohesion: 0.25
Nodes (7): getCategories, getFavoriteCategories, getProfile, reconcilePendingCategorySync, saveLocalCategories, syncFavoriteCategories, updateProfile

### Community 111 - "@immutable"
Cohesion: 0.29
Nodes (7): @immutable, AppThemeData, ThemeConfig, AppColors, AppTextStyles, AppBorders, SharedPreferencesSingleton

### Community 112 - "failures.dart"
Cohesion: 0.43
Nodes (6): CacheFailure, Failure, message, props, ServerFailure, ValidationFailure

### Community 113 - "article_card.dart"
Cohesion: 0.17
Nodes (11): ArticleCard, author, date, imagePath, isDwonload, isFav, title, package:mind_feed/features/home/presentation/widgets/add_to_favorite_article_card.dart (+3 more)

### Community 114 - "app_images.dart"
Cohesion: 0.12
Nodes (15): Assets, assetsImagesBack, assetsImagesBusinessIcon, assetsImagesEducationIcon, assetsImagesJustTest, assetsImagesLogo, assetsImagesMeJustForTest, assetsImagesMITNewsAICoding (+7 more)

### Community 116 - "page_view_item.dart"
Cohesion: 0.33
Nodes (5): build, description, PageViewItem, title, package:google_fonts/google_fonts.dart

### Community 117 - "Cubit"
Cohesion: 0.60
Nodes (4): SearchInitial, SearchState, Cubit, SearchCubit

### Community 118 - "categories_view_body.dart"
Cohesion: 0.29
Nodes (6): build, categories, CategoriesViewBody, userEntity, package:mind_feed/features/auth/presentation/controllers/categories_cubit/categories_cubit.dart, package:mind_feed/features/auth/presentation/widgets/category_card.dart

### Community 119 - "Equatable"
Cohesion: 0.33
Nodes (6): Equatable, AuthResultEntity, ArticleModel, TagModel, ArticleEntity, TagEntity

### Community 120 - "logout_use_case.dart"
Cohesion: 0.33
Nodes (5): articlesRepo, authRepo, call, localDataSource, LogoutUseCase

### Community 121 - "add_to_favorite_article_card.dart"
Cohesion: 0.40
Nodes (5): AddToFavoriteArticleCard, _AddToFavoriteArticleCardState, build, createState, isFav

### Community 122 - "category_entity.dart"
Cohesion: 0.25
Nodes (7): CategoryModel, CategoryEntity, description, id, name, props, slug

### Community 123 - "categories_view_test.dart"
Cohesion: 0.18
Nodes (10): Map, package:mind_feed/features/auth/presentation/views/categories_view.dart, allCategories, getCategories, getFavoriteCategories, main, setFavoriteCategories, shouldThrow (+2 more)

### Community 124 - "tag_model.dart"
Cohesion: 0.40
Nodes (4): fromEntity, fromJson, toJson, package:mind_feed/features/home/domain/entities/tag_entity.dart

### Community 125 - "publish_article_use_case.dart"
Cohesion: 0.40
Nodes (4): call, PublishArticleUseCase, repo, package:mind_feed/core/errors/failures.dart

### Community 127 - "build"
Cohesion: 0.40
Nodes (5): build, build, build, AppRoutes.article, AppRoutes.profile

### Community 128 - "package:mind_feed/core/networking/api_result.dart"
Cohesion: 0.10
Nodes (22): ArticlesRepositoryImpl, ArticlesRepository, call, DeleteArticleUseCase, repo, call, GetHomeFeedUseCase, repo (+14 more)

### Community 130 - "_EditorialCardStackState"
Cohesion: 0.67
Nodes (3): EditorialCardStack, _EditorialCardStackState, SingleTickerProviderStateMixin

### Community 131 - "ArticlesRemoteDataSource"
Cohesion: 0.67
Nodes (3): ArticlesRemoteDataSource, ArticlesRemoteDataSourceImpl, FakeArticlesRemoteDataSource

### Community 132 - "State"
Cohesion: 0.17
Nodes (16): ChangePasswordForm, _ChangePasswordFormState, CheckCodeViewBody, _CheckCodeViewBodyState, LoginForm, _LoginFormState, SendCodeViewBody, _SendCodeViewBodyState (+8 more)

## Knowledge Gaps
- **1379 isolated node(s):** `capitalize`, `reversed`, `toInt`, `toDouble`, `toNum` (+1374 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1550 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `UserEntity` connect `package:mind_feed/features/auth/domain/entities/user_entity.dart` to `category_onboarding_clean_architecture_test.dart`, `main.dart`, `categories_view.dart`, `user_entity.dart`, `category_sync_hardening_test.dart`, `auth_repo_impl.dart`, `offline_articles_and_logout_test.dart`, `check_code_view_body.dart`, `categories_view_body.dart`, `profile_repo_impl.dart`, `cache_helper.dart`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **Why does `SignupCubit` connect `auth_api_source.dart` to `sign_up_form_body.dart`, `State`, `Cubit`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Why does `ArticlesRepository` connect `package:mind_feed/core/networking/api_result.dart` to `articles_repo.dart`, `setup_service_locator.dart`, `package:mind_feed/features/home/domain/entities/article_entity.dart`, `user_articles.dart`, `get_categories_use_case.dart`, `logout_use_case.dart`, `publish_article_use_case.dart`?**
  _High betweenness centrality (0.012) - this node is a cross-community bridge._
- **What connects `capitalize`, `reversed`, `toInt` to the rest of the system?**
  _1379 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.01652892561983471 - nodes in this community are weakly interconnected._
- **Should `app_icons.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.02666666666666667 - nodes in this community are weakly interconnected._
- **Should `category_onboarding_clean_architecture_test.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._