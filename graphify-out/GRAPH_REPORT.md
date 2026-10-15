# Graph Report - MindFeed-main  (2026-10-15)

## Corpus Check
- 226 files · ~255,706 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2228 nodes · 3288 edges · 132 communities
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
- search_bar.dart
- app_routes.dart
- sign_up_view_body.dart
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
- custom_text_field.dart
- logout_use_case.dart
- device_preference_notifier.dart
- package:mind_feed/config/routes/app_routes.dart
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
- VoidCallback?
- custom_drawer.dart
- Fake
- login_cubit.dart
- theme_mode_cubit.dart
- package:mind_feed/core/constants/borders.dart
- editorial_saved_stack.dart
- shared_preferences_singleton.dart
- login_form.dart
- main_view.dart
- article_view.dart
- MindFeed Editorial UI Transformation Plan
- Hermes Review Result: S1-editorial-shell
- string_extension.dart
- MindFeed Phase 0 — Repository and Live Database Reconciliation Report
- ArticlesRepository
- package:mind_feed/features/home/domain/entities/article_entity.dart
- category_card.dart
- package:flutter/foundation.dart
- Orchestration State
- package:flutter_test/flutter_test.dart
- main.dart
- signup_params.dart
- add_article.dart
- user_entity.dart
- user_articles.dart
- article_data_and_domain_test.dart
- Design Context
- package:mind_feed/core/design/editorial_models.dart
- author_view.dart
- ArticlesLocalDataSource
- Project Context: Mind Feed
- offline_articles_and_logout_test.dart
- package:supabase_flutter/supabase_flutter.dart
- datasources/articles_local_data_source.dart
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
- setup_service_locator.dart
- categories_view.dart
- home_view_body.dart
- settings_cubit.dart
- article_model.dart
- List
- api_result.dart
- MindFeed Phase 1 — Database Baseline & Migration Reconciliation Verification Report
- MindFeed Phase 1 — Database Baseline and Migration Reconciliation Report
- static const String
- get_categories_use_case.dart
- password_text_field.dart
- profile_repo.dart
- login_view.dart
- failures.dart
- article_card_of_author.dart
- app_images.dart
- widget_test.dart
- page_view_item.dart
- package:flutter_bloc/flutter_bloc.dart
- list_saved_articles.dart
- Equatable
- get_articles_by_category_use_case.dart
- State
- category_entity.dart
- categories_view_test.dart
- tag_model.dart
- publish_article_use_case.dart
- build
- package:mind_feed/core/networking/api_result.dart
- ArticlesRemoteDataSource
- send_code_view_body.dart

## God Nodes (most connected - your core abstractions)
1. `Continuation Packet: S1-editorial-shell-recovery` - 19 edges
2. `Task Packet: S1-editorial-shell` - 18 edges
3. `Task Packet: S2-auth-refinement` - 18 edges
4. `ArticlesRepository` - 17 edges
5. `Mini-requirements` - 16 edges
6. `UserEntity` - 13 edges
7. `SignupCubit` - 13 edges
8. `AddArticleCubit` - 12 edges
9. `CategoriesCubit` - 12 edges
10. `AuthRepository` - 11 edges

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

## Communities (132 total, 0 thin omitted)

### Community 0 - "app_colors.dart"
Cohesion: 0.02
Nodes (120): almostBlack, amber, amberDark, amberDarker, black, blue, blueMain, blush (+112 more)

### Community 1 - "app_icons.dart"
Cohesion: 0.03
Nodes (74): add, alternateEmailRounded, AppIcons, arrowBackRounded, arrowForwardIosRounded, articleOutlined, boltRounded, bookmark (+66 more)

### Community 2 - "category_onboarding_clean_architecture_test.dart"
Cohesion: 0.09
Nodes (22): PostgrestException, categoriesList, clearDownloadedArticles, clearOfflineCalled, from, fromInvoked, getCategories, invokedParams (+14 more)

### Community 3 - "app_text_styles.dart"
Cohesion: 0.09
Nodes (21): bodyLarge, bodyMedium, bodySmall, displayLarge, displayMedium, displaySmall, headlineLarge, headlineMedium (+13 more)

### Community 4 - "add_article_cubit.dart"
Cohesion: 0.20
Nodes (15): AddArticleError, AddArticleFileLoaded, AddArticleInitial, AddArticleLoading, AddArticleState, content, fileName, message (+7 more)

### Community 5 - "editorial_card_stack.dart"
Cohesion: 0.09
Nodes (23): _animController, build, _cards, createState, didUpdateWidget, dispose, _dragOffset, EditorialCardStack (+15 more)

### Community 6 - "home_of_add_article_view.dart"
Cohesion: 0.08
Nodes (25): build, _clearText, createState, devicePreferenceNotifier, dispose, _fullView, _getFileContents, Home (+17 more)

### Community 7 - "search_bar.dart"
Cohesion: 0.13
Nodes (14): build, controller, CustomSearchBar, hintText, onChanged, semanticLabel, trailingSearchIcon, build (+6 more)

### Community 8 - "app_routes.dart"
Cohesion: 0.06
Nodes (34): addArticle, AppRoutes, article, articlesCategory, articlesSaved, author, categories, changePassword (+26 more)

### Community 9 - "sign_up_view_body.dart"
Cohesion: 0.11
Nodes (19): build, ChangePasswordViewBody, email, build, build, build, SignUpViewBody, package:mind_feed/core/helpers/custom_show_snack_bar.dart (+11 more)

### Community 10 - "app_theme_data.dart"
Cohesion: 0.06
Nodes (34): card, checkbox, chip, dialog, dropdownMenu, filledButton, floatingActionButton, iconButton (+26 more)

### Community 11 - "category_sync_hardening_test.dart"
Cohesion: 0.11
Nodes (17): Directory, MockProfileRemoteDataSource, package:mind_feed/features/auth/domain/usecases/logout_use_case.dart, package:mind_feed/features/home/data/datasources/articles_local_data_source.dart, categoriesList, clearAllDownloadedArticles, cleared, getCategories (+9 more)

### Community 12 - "collections_cubit.dart"
Cohesion: 0.12
Nodes (22): CollectionsInitial, CollectionsLoaded, CollectionsLoading, CollectionsState, stories, _allStories, CollectionsCubit, deleteArticle (+14 more)

### Community 13 - "markdown_text_input.dart"
Cohesion: 0.07
Nodes (26): Function, int?, actions, actionWidget, _basicInkwell, build, controller, _controllerListener (+18 more)

### Community 14 - "Business Requirements Document (BRD)"
Cohesion: 0.08
Nodes (24): 1.1 Purpose, 1.2 Business Problem Statement, 1.3 Vision & Solution, 1. Executive Summary, 2. Business Objectives & Key Performance Indicators (KPIs), 3.1 Competitive Landscape, 3.2 Target Audience Segments, 3. Market Analysis & Value Proposition (+16 more)

### Community 15 - "StatelessWidget"
Cohesion: 0.07
Nodes (33): IconData, active, build, icon, label, MainNavigationBar, _Nav, onDestinationSelected (+25 more)

### Community 16 - "profile_view_body.dart"
Cohesion: 0.33
Nodes (5): build, ProfileViewBody, package:mind_feed/features/profile/presentation/widget/personal_infromation.dart, package:mind_feed/features/profile/presentation/widget/profile_app_bar.dart, package:mind_feed/features/profile/presentation/widget/user_articles.dart

### Community 17 - "auth_repo_impl.dart"
Cohesion: 0.09
Nodes (23): dart:convert, CacheHelper, cacheHelper, getUser, key, UserCacheDataSource, authApiSource, cacheHelper (+15 more)

### Community 18 - "package:flutter/material.dart"
Cohesion: 0.10
Nodes (15): customShowSnackBar, duration, authBackground, build, SignUpForm, build, ListForSavedArticles, build (+7 more)

### Community 19 - "Mini-requirements"
Cohesion: 0.09
Nodes (21): 1. Mandatory Authentication & Onboarding, 2. Home Feed & Discovery, 3. Article Reader, Starring & Sharing, 4. Offline Mode (Text-Only), 5. Article Drafting, Preview, Publishing & Lifecycle, 6. Personal Collections & Settings, Acceptance Criteria, Business Rules (+13 more)

### Community 20 - "Continuation Packet: S1-editorial-shell-recovery"
Cohesion: 0.10
Nodes (19): Allowed edit scope, Areas that must not be redesigned, Completed work, Continuation objective, Continuation Packet: S1-editorial-shell-recovery, Current failures, Exact files to inspect, Exact remaining work (+11 more)

### Community 21 - "package:mind_feed/core/constants/app_colors.dart"
Cohesion: 0.10
Nodes (16): build, CustomLoadingIndecator, build, ForgetPasswordText, build, CustombackgroundForTheDrawerInHomePage, build, currentPage (+8 more)

### Community 22 - "package:mind_feed/core/constants/app_text_styles.dart"
Cohesion: 0.11
Nodes (15): build, CustomSliverAppBarForArticlesSaved, ArticleCardInformation, author, build, date, title, author (+7 more)

### Community 23 - "package:mind_feed/core/constants/app_images.dart"
Cohesion: 0.08
Nodes (21): build, DownloadedArticlesViewBody, build, FavoriteMoviesViewBody, ArticleViewBody, build, AuthorCard, build (+13 more)

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
Cohesion: 0.12
Nodes (17): getCategories, getFavoriteCategories, getProfile, _isReconciling, ProfileRepoImpl, reconcilePendingCategorySync, remoteDataSource, saveLocalCategories (+9 more)

### Community 28 - "editorial_design.dart"
Cohesion: 0.12
Nodes (15): authorName, build, _buildShareAction, createState, EditorialIconButton, icon, initialFollowing, initState (+7 more)

### Community 29 - "custom_text_field.dart"
Cohesion: 0.17
Nodes (11): build, CustomTextField, hintText, keyboardType, obscureText, onChanged, prefixIcon, suffixIcon (+3 more)

### Community 30 - "logout_use_case.dart"
Cohesion: 0.09
Nodes (21): AuthRepoImpl, AuthRepository, call, LoginUseCase, repo, articlesRepo, authRepo, call (+13 more)

### Community 31 - "device_preference_notifier.dart"
Cohesion: 0.12
Nodes (16): int get, copyWith, DevicePreferenceNotifier, DevicePreferences, hashCode, isDarkMode, isSplitLayout, loadDevicePreferences (+8 more)

### Community 32 - "package:mind_feed/config/routes/app_routes.dart"
Cohesion: 0.07
Nodes (27): build, isleft, ListCard, listCardBody, ArticleCard, author, date, imagePath (+19 more)

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
Cohesion: 0.07
Nodes (23): build, MoreVertIcon, build, _buildRequirementRow, password, PasswordRequirements, AuthorPersonalInfo, build (+15 more)

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
Cohesion: 0.15
Nodes (13): autovalidateMode, build, _confirmPasswordController, createState, dispose, _emailController, formKey, initState (+5 more)

### Community 43 - "onboarding_view_body.dart"
Cohesion: 0.17
Nodes (12): build, createState, _currentPage, dispose, initState, OnboardingViewBody, _OnboardingViewBodyState, _pageController (+4 more)

### Community 44 - "email_confirmation_and_auth_flow_test.dart"
Cohesion: 0.09
Nodes (21): FakeNetworkInfo, HttpOverrides, async, authRepo, connected, createHttpClient, fakeApiSource, fakeUserCache (+13 more)

### Community 45 - "custom_app_bar.dart"
Cohesion: 0.12
Nodes (17): AdvancedDrawerValue, build, CustomAppBar, _handleMenuButtonPressed, title, build, DownloadedArticlesView, routeName (+9 more)

### Community 46 - "change_password_form.dart"
Cohesion: 0.18
Nodes (11): autovalidateMode, build, ChangePasswordForm, _ChangePasswordFormState, confirmPassword, createState, email, formKey (+3 more)

### Community 47 - "auth_api_source.dart"
Cohesion: 0.05
Nodes (49): email, errorMessage, isUserAlreadyRegistered, SignupFailure, SignupInitial, SignupLoading, SignupRequiresConfirmation, SignupState (+41 more)

### Community 48 - "constants.dart"
Cohesion: 0.17
Nodes (11): AppConstants, appName, compact, page, roomy, supabaseAnonKey, supabaseUrl, themeModeKey (+3 more)

### Community 49 - "categories_cubit.dart"
Cohesion: 0.19
Nodes (16): CategoriesFailure, CategoriesInitial, CategoriesLoading, CategoriesSelectionChanged, CategoriesState, CategoriesSuccess, errorMessage, isPendingSync (+8 more)

### Community 50 - "VoidCallback?"
Cohesion: 0.12
Nodes (14): actionText, AuthPromptLink, build, onTap, promptText, build, NoAccountText, onTap (+6 more)

### Community 51 - "custom_drawer.dart"
Cohesion: 0.17
Nodes (11): build, CustomDrawer, routeName, build, package:flutter_svg/flutter_svg.dart, package:mind_feed/features/collections/presentation/views/downloaded_articles_view.dart, package:mind_feed/features/collections/presentation/views/favorite_movies_view.dart, package:mind_feed/features/settings/presentation/views/settings_view.dart (+3 more)

### Community 52 - "Fake"
Cohesion: 0.10
Nodes (23): Fake, GoTrueClient, _client, getCategories, getFavoriteCategories, getProfile, ProfileRemoteDataSource, ProfileRemoteDataSourceImpl (+15 more)

### Community 53 - "login_cubit.dart"
Cohesion: 0.26
Nodes (12): email, errorMessage, LoginFailure, LoginInitial, LoginLoading, LoginState, LoginSuccess, eitherFailureOrLogin (+4 more)

### Community 54 - "theme_mode_cubit.dart"
Cohesion: 0.33
Nodes (10): ThemeModeDark, ThemeModeInitial, ThemeModeLight, ThemeModeState, ThemeModeSystem, changeThemeMode, getThemeMode, ThemeModeCubit (+2 more)

### Community 55 - "package:mind_feed/core/constants/borders.dart"
Cohesion: 0.08
Nodes (22): build, EditorialCard, item, onLike, onOpen, onSave, onShare, showActions (+14 more)

### Community 56 - "editorial_saved_stack.dart"
Cohesion: 0.18
Nodes (10): build, _buildDismissibleCard, createState, _deleteItem, didUpdateWidget, initState, items, onDeleteArticle (+2 more)

### Community 57 - "shared_preferences_singleton.dart"
Cohesion: 0.17
Nodes (11): clear, getBool, getKeys, getString, init, _instance, remove, setBool (+3 more)

### Community 58 - "login_form.dart"
Cohesion: 0.20
Nodes (10): GlobalKey, autovalidateMode, createState, email, formKey, LoginForm, _LoginFormState, password (+2 more)

### Community 59 - "main_view.dart"
Cohesion: 0.22
Nodes (9): build, createState, initState, MainView, _MainViewState, routeName, selectedIndex, package:mind_feed/features/profile/data/services/category_sync_reconciler.dart (+1 more)

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

### Community 65 - "ArticlesRepository"
Cohesion: 0.18
Nodes (9): ArticlesRepositoryImpl, ArticlesRepository, call, GetSavedArticlesUseCase, repo, call, repo, ToggleStarUseCase (+1 more)

### Community 66 - "package:mind_feed/features/home/domain/entities/article_entity.dart"
Cohesion: 0.22
Nodes (7): call, GetArticleDetailsUseCase, repo, call, repo, SearchArticlesUseCase, package:mind_feed/features/home/domain/entities/article_entity.dart

### Community 67 - "category_card.dart"
Cohesion: 0.20
Nodes (8): build, category, CategoryCard, isSelected, onTap, build, Logo, package:flutter_svg/svg.dart

### Community 68 - "package:flutter/foundation.dart"
Cohesion: 0.25
Nodes (7): Client, http.BaseClient, _inner, send, SupabaseInterceptor, package:flutter/foundation.dart, package:http/http.dart

### Community 69 - "Orchestration State"
Cohesion: 0.25
Nodes (7): Active file leases, Blockers and decisions, Last verified checkpoint, Milestones, Orchestration State, Project, Stage tracker

### Community 70 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.15
Nodes (11): MethodChannel, package:flutter/services.dart, package:flutter_test/flutter_test.dart, package:mind_feed/core/design/editorial_card_stack.dart, package:mind_feed/core/design/editorial_saved_stack.dart, package:mind_feed/core/networking/network_info.dart, harness, main (+3 more)

### Community 71 - "main.dart"
Cohesion: 0.22
Nodes (8): globalDevicePreferenceNotifier, init, initFlutter, loadDevicePreferences, main, package:mind_feed/core/constants/constants.dart, package:mind_feed/core/networking/supabase_interceptor.dart, package:mind_feed/main_app.dart

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

### Community 80 - "ArticlesLocalDataSource"
Cohesion: 0.10
Nodes (20): ArticlesLocalDataSourceImpl, ArticlesLocalDataSource, clearAllDownloadedArticles, deleteDownloadedArticle, getDownloadedArticleById, getDownloadedArticles, saveDownloadedArticle, call (+12 more)

### Community 81 - "Project Context: Mind Feed"
Cohesion: 0.33
Nodes (5): 1. Overview, 2. Architecture & Directory Structure, 3. Technology Stack & Key Libraries, 4. Recent Project Changes, Project Context: Mind Feed

### Community 82 - "offline_articles_and_logout_test.dart"
Cohesion: 0.11
Nodes (18): GoTrueClient get, package:mind_feed/features/home/domain/usecases/delete_downloaded_article_use_case.dart, async, auth, authClient, clearAllCalled, clearAllDownloadedArticles, createArticle (+10 more)

### Community 83 - "package:supabase_flutter/supabase_flutter.dart"
Cohesion: 0.22
Nodes (8): ../errors/exceptions.dart, ../errors/failures.dart, ApiErrorHandler, code, handle, message, toFailure, package:supabase_flutter/supabase_flutter.dart

### Community 84 - "datasources/articles_local_data_source.dart"
Cohesion: 0.20
Nodes (9): _box, boxName, clearAllDownloadedArticles, deleteDownloadedArticle, getDownloadedArticleById, getDownloadedArticles, _openBox, saveDownloadedArticle (+1 more)

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
Cohesion: 0.22
Nodes (8): call, CategorySaveOutcome, errorMessage, isLocalSaved, isPendingSync, isRemoteSynced, repository, SaveFavoriteCategoriesUseCase

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
Cohesion: 0.13
Nodes (14): getIt, setupServiceLocator, AuthApiSource, package:get_it/get_it.dart, package:mind_feed/features/auth/data/repos/auth_repo_impl.dart, package:mind_feed/features/home/domain/usecases/delete_article_use_case.dart, package:mind_feed/features/home/domain/usecases/download_article_text_use_case.dart, package:mind_feed/features/home/domain/usecases/get_article_details_use_case.dart (+6 more)

### Community 99 - "categories_view.dart"
Cohesion: 0.09
Nodes (23): @HiveType, fromEntity, fromJson, toJson, toUserEntity, UserModel, UserEntity, build (+15 more)

### Community 100 - "home_view_body.dart"
Cohesion: 0.15
Nodes (13): Animation, AnimationController, _breathingAnimation, _breathingController, createState, dispose, _fetchRealStories, HomeViewBody (+5 more)

### Community 101 - "settings_cubit.dart"
Cohesion: 0.12
Nodes (19): @immutable, cachedMegabytes, copyWith, dataPreservation, SettingsInitial, SettingsLoaded, SettingsState, wifiOnly (+11 more)

### Community 102 - "article_model.dart"
Cohesion: 0.29
Nodes (6): copyWith, fromEntity, fromJson, _parseDateTime, _parseTags, toJson

### Community 103 - "List"
Cohesion: 0.17
Nodes (11): accessToken, email, hasActiveSession, props, userId, id, name, props (+3 more)

### Community 104 - "api_result.dart"
Cohesion: 0.39
Nodes (7): ApiResult, data, failure, FailureResult, Success, R, T

### Community 105 - "MindFeed Phase 1 — Database Baseline & Migration Reconciliation Verification Report"
Cohesion: 0.17
Nodes (11): 1. Executive Summary, 2.1 Baseline Migration: `supabase/migrations/20261015000000_baseline_schema.sql`, 2.2 Catalog Seed Migration: `supabase/migrations/20261015000001_seed_catalog.sql`, 2.3 Supabase Configuration & Supplemental Seeds, 2. Deliverables Inventory in Version Control, 3. Local Clean Database Verification Results, 4.1 Migration History Tracking, 4.2 Live Data Preservation Audit (+3 more)

### Community 106 - "MindFeed Phase 1 — Database Baseline and Migration Reconciliation Report"
Cohesion: 0.18
Nodes (10): 1. Executive Summary, 2.1 Baseline Migration, 2.2 Seed Migrations & Local Seed Files, 2.3 Production Editorial Articles Backup, 2. Deliverables Inventory, 3. Live Database Verification and Integrity Evidence, 4. Migration History Reconciliation Evidence, 5. Phase 1 Completion & Next Steps (+2 more)

### Community 107 - "static const String"
Cohesion: 0.06
Nodes (29): AdvancedDrawerController, build, ChangePasswordView, email, routeName, build, CheckCodeView, email (+21 more)

### Community 108 - "get_categories_use_case.dart"
Cohesion: 0.22
Nodes (7): fromEntity, fromJson, toJson, call, GetCategoriesUseCase, repo, package:mind_feed/features/home/domain/entities/category_entity.dart

### Community 109 - "password_text_field.dart"
Cohesion: 0.18
Nodes (11): FocusNode, build, controller, createState, dispose, hintText, _isObscured, onChanged (+3 more)

### Community 110 - "profile_repo.dart"
Cohesion: 0.25
Nodes (7): getCategories, getFavoriteCategories, getProfile, reconcilePendingCategorySync, saveLocalCategories, syncFavoriteCategories, updateProfile

### Community 111 - "login_view.dart"
Cohesion: 0.25
Nodes (7): build, loginCubit, LoginView, routeName, package:mind_feed/features/auth/domain/usecases/login_use_case.dart, package:mind_feed/features/auth/presentation/controllers/login_cubit/login_cubit.dart, package:mind_feed/features/auth/presentation/widgets/login_view_body.dart

### Community 112 - "failures.dart"
Cohesion: 0.43
Nodes (6): CacheFailure, Failure, message, props, ServerFailure, ValidationFailure

### Community 113 - "article_card_of_author.dart"
Cohesion: 0.29
Nodes (6): ArticleCardOfAuthor, build, imagePath, isDwonload, isFav, title

### Community 114 - "app_images.dart"
Cohesion: 0.12
Nodes (15): Assets, assetsImagesBack, assetsImagesBusinessIcon, assetsImagesEducationIcon, assetsImagesJustTest, assetsImagesLogo, assetsImagesMeJustForTest, assetsImagesMITNewsAICoding (+7 more)

### Community 115 - "widget_test.dart"
Cohesion: 0.29
Nodes (6): package:mind_feed/features/home/presentation/views/article_view.dart, package:mind_feed/features/main/presentation/views/main_view.dart, package:mind_feed/features/main/presentation/widgets/main_navigation_bar.dart, package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart, editorialHarness, main

### Community 116 - "page_view_item.dart"
Cohesion: 0.33
Nodes (5): build, description, PageViewItem, title, package:google_fonts/google_fonts.dart

### Community 117 - "package:flutter_bloc/flutter_bloc.dart"
Cohesion: 0.15
Nodes (13): SearchInitial, SearchState, Cubit, SearchCubit, build, _buildThemeCard, ThemeWidget, build (+5 more)

### Community 118 - "list_saved_articles.dart"
Cohesion: 0.40
Nodes (4): build, ListSavedArticles, routeName, package:mind_feed/features/collections/presentation/views/articles_saved.dart

### Community 119 - "Equatable"
Cohesion: 0.33
Nodes (6): Equatable, AuthResultEntity, ArticleModel, TagModel, ArticleEntity, TagEntity

### Community 120 - "get_articles_by_category_use_case.dart"
Cohesion: 0.50
Nodes (3): call, GetArticlesByCategoryUseCase, repo

### Community 121 - "State"
Cohesion: 0.19
Nodes (13): EditorialFollowButton, _EditorialFollowButtonState, EditorialSavedStack, _EditorialSavedStackState, MarkdownTextInput, _MarkdownTextInputState, AddToFavoriteArticleCard, _AddToFavoriteArticleCardState (+5 more)

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
Cohesion: 0.13
Nodes (14): call, DeleteArticleUseCase, repo, call, GetHomeFeedUseCase, repo, call, repo (+6 more)

### Community 131 - "ArticlesRemoteDataSource"
Cohesion: 0.67
Nodes (3): ArticlesRemoteDataSource, ArticlesRemoteDataSourceImpl, FakeArticlesRemoteDataSource

### Community 132 - "send_code_view_body.dart"
Cohesion: 0.22
Nodes (9): AutovalidateMode, FormState, autovalidateMode, createState, email, formKey, SendCodeViewBody, _SendCodeViewBodyState (+1 more)

## Knowledge Gaps
- **1387 isolated node(s):** `capitalize`, `reversed`, `toInt`, `toDouble`, `toNum` (+1382 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1558 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SignupCubit` connect `auth_api_source.dart` to `sign_up_view_body.dart`, `sign_up_form_body.dart`, `package:flutter_bloc/flutter_bloc.dart`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Why does `UserEntity` connect `categories_view.dart` to `category_onboarding_clean_architecture_test.dart`, `main.dart`, `user_entity.dart`, `category_sync_hardening_test.dart`, `auth_repo_impl.dart`, `offline_articles_and_logout_test.dart`, `check_code_view_body.dart`, `profile_repo_impl.dart`, `cache_helper.dart`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Why does `ArticlesRepository` connect `ArticlesRepository` to `articles_repo.dart`, `package:mind_feed/core/networking/api_result.dart`, `setup_service_locator.dart`, `package:mind_feed/features/home/domain/entities/article_entity.dart`, `user_articles.dart`, `get_categories_use_case.dart`, `get_articles_by_category_use_case.dart`, `publish_article_use_case.dart`, `logout_use_case.dart`?**
  _High betweenness centrality (0.014) - this node is a cross-community bridge._
- **What connects `capitalize`, `reversed`, `toInt` to the rest of the system?**
  _1387 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.01652892561983471 - nodes in this community are weakly interconnected._
- **Should `app_icons.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.02666666666666667 - nodes in this community are weakly interconnected._
- **Should `category_onboarding_clean_architecture_test.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.08695652173913043 - nodes in this community are weakly interconnected._