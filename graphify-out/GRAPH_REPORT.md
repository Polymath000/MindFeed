# Graph Report - MindFeed-main  (2026-10-11)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 1590 nodes · 2240 edges · 92 communities
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e746009f`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- app_colors.dart
- app_icons.dart
- main.dart
- app_text_styles.dart
- static const String
- editorial_card_stack.dart
- home_of_add_article_view.dart
- password_text_field.dart
- app_routes.dart
- signup_cubit.dart
- app_theme_data.dart
- cache_helper.dart
- articles_saved.dart
- markdown_text_input.dart
- Business Requirements Document (BRD)
- StatelessWidget
- package:flutter/material.dart
- auth_repo_impl.dart
- package:mind_feed/core/constants/app_images.dart
- Mini-requirements
- Continuation Packet: S1-editorial-shell-recovery
- package:mind_feed/core/constants/app_colors.dart
- package:mind_feed/core/constants/app_icons.dart
- package:mind_feed/core/constants/app_text_styles.dart
- Task Packet: S1-editorial-shell
- Task Packet: S2-auth-refinement
- setup_service_locator.dart
- api_result.dart
- editorial_design.dart
- package:mind_feed/core/constants/borders.dart
- auth_repo.dart
- device_preference_notifier.dart
- article_card.dart
- borders.dart
- editorial_models.dart
- signup_view.dart
- MindFeed Editorial UI Specification & Architecture
- package:mind_feed/config/routes/app_routes.dart
- next_button.dart
- settings_view_body.dart
- Mind Feed
- format_markdown.dart
- sign_up_form_body.dart
- onboarding_view_body.dart
- check_code_view_body.dart
- constants.dart
- State
- auth_api_source.dart
- change_password_form.dart
- downloaded_articles_view.dart
- aricles_by_categories.dart
- custom_drawer.dart
- profile_remote_data_source.dart
- login_cubit.dart
- send_code_view_body.dart
- main_navigation_bar.dart
- editorial_saved_stack.dart
- shared_preferences_singleton.dart
- login_form.dart
- widget_test.dart
- article_view.dart
- MindFeed Editorial UI Transformation Plan
- Hermes Review Result: S1-editorial-shell
- string_extension.dart
- profile_view.dart
- editorial_card.dart
- main_view.dart
- home_view.dart
- package:flutter/foundation.dart
- Orchestration State
- login_view.dart
- api_error_handler.dart
- signup_params.dart
- add_article.dart
- List
- user_articles.dart
- custom_app_bar.dart
- Design Context
- package:mind_feed/core/design/editorial_models.dart
- author_view.dart
- list_card.dart
- Project Context: Mind Feed
- custom_article_card_of_profile.dart
- categories_view_body.dart
- add_to_favorite_article_card.dart
- profile_view_body.dart
- Exception
- login_params.dart
- no_account_text.dart

## God Nodes (most connected - your core abstractions)
1. `Continuation Packet: S1-editorial-shell-recovery` - 19 edges
2. `Task Packet: S1-editorial-shell` - 18 edges
3. `Task Packet: S2-auth-refinement` - 18 edges
4. `Mini-requirements` - 16 edges
5. `AddArticleCubit` - 12 edges
6. `ThemeModeCubit` - 10 edges
7. `LoginCubit` - 10 edges
8. `SignupCubit` - 10 edges
9. `Mind Feed` - 9 edges
10. `Hermes Review Result: S1-editorial-shell` - 9 edges

## Surprising Connections (you probably didn't know these)
- `build` --references--> `LoginCubit`  [EXTRACTED]
  lib/features/auth/presentation/widgets/login_form.dart → lib/features/auth/presentation/controllers/login_cubit/login_cubit.dart
- `UserModel` --inherits--> `UserEntity`  [EXTRACTED]
  lib/features/auth/data/models/user_model.dart → lib/features/auth/domain/entities/user_entity.dart
- `initState` --references--> `CollectionsCubit`  [EXTRACTED]
  lib/features/collections/presentation/views/articles_saved.dart → lib/features/collections/presentation/cubit/collections_cubit.dart
- `_SignUpFormBodyState` --references--> `SignupCubit`  [EXTRACTED]
  lib/features/auth/presentation/widgets/sign_up_form_body.dart → lib/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart
- `_LoginFormState` --references--> `LoginCubit`  [EXTRACTED]
  lib/features/auth/presentation/widgets/login_form.dart → lib/features/auth/presentation/controllers/login_cubit/login_cubit.dart

## Import Cycles
- None detected.

## Communities (92 total, 0 thin omitted)

### Community 0 - "app_colors.dart"
Cohesion: 0.02
Nodes (120): almostBlack, amber, amberDark, amberDarker, black, blue, blueMain, blush (+112 more)

### Community 1 - "app_icons.dart"
Cohesion: 0.03
Nodes (74): add, alternateEmailRounded, AppIcons, arrowBackRounded, arrowForwardIosRounded, articleOutlined, boltRounded, bookmark (+66 more)

### Community 2 - "main.dart"
Cohesion: 0.06
Nodes (42): SearchInitial, SearchState, cachedMegabytes, copyWith, dataPreservation, SettingsInitial, SettingsLoaded, SettingsState (+34 more)

### Community 3 - "app_text_styles.dart"
Cohesion: 0.05
Nodes (42): @immutable, app_theme_data.dart, bool?, DynamicSchemeVariant, AppThemeData, dark, dynamicSchemeVariant, isAmoledSelected (+34 more)

### Community 4 - "static const String"
Cohesion: 0.05
Nodes (38): Assets, assetsImagesBack, assetsImagesBusinessIcon, assetsImagesEducationIcon, assetsImagesJustTest, assetsImagesLogo, assetsImagesMeJustForTest, assetsImagesMITNewsAICoding (+30 more)

### Community 5 - "editorial_card_stack.dart"
Cohesion: 0.05
Nodes (39): Animation, AnimationController, _animController, build, _cards, createState, didUpdateWidget, dispose (+31 more)

### Community 6 - "home_of_add_article_view.dart"
Cohesion: 0.06
Nodes (40): AddArticleError, AddArticleFileLoaded, AddArticleInitial, AddArticleLoading, AddArticleState, content, fileName, message (+32 more)

### Community 7 - "password_text_field.dart"
Cohesion: 0.06
Nodes (36): FocusNode, build, CustomTextField, hintText, keyboardType, obscureText, onChanged, prefixIcon (+28 more)

### Community 8 - "app_routes.dart"
Cohesion: 0.06
Nodes (34): addArticle, AppRoutes, article, articlesCategory, articlesSaved, author, categories, changePassword (+26 more)

### Community 9 - "signup_cubit.dart"
Cohesion: 0.08
Nodes (30): errorMessage, SignupFailure, SignupInitial, SignupLoading, SignupState, SignupSuccess, eitherFailureOrSignup, SignupCubit (+22 more)

### Community 10 - "app_theme_data.dart"
Cohesion: 0.06
Nodes (30): card, checkbox, chip, dialog, dropdownMenu, filledButton, floatingActionButton, iconButton (+22 more)

### Community 11 - "cache_helper.dart"
Cohesion: 0.07
Nodes (26): @HiveType, Box, box, clearData, containsKey, getData, getDataFromHive, getDataString (+18 more)

### Community 12 - "articles_saved.dart"
Cohesion: 0.09
Nodes (26): CollectionsInitial, CollectionsLoaded, CollectionsLoading, CollectionsState, stories, _allStories, CollectionsCubit, deleteArticle (+18 more)

### Community 13 - "markdown_text_input.dart"
Cohesion: 0.07
Nodes (28): Function, int?, actions, actionWidget, _basicInkwell, build, controller, _controllerListener (+20 more)

### Community 14 - "Business Requirements Document (BRD)"
Cohesion: 0.08
Nodes (24): 1.1 Purpose, 1.2 Business Problem Statement, 1.3 Vision & Solution, 1. Executive Summary, 2. Business Objectives & Key Performance Indicators (KPIs), 3.1 Competitive Landscape, 3.2 Target Audience Segments, 3. Market Analysis & Value Proposition (+16 more)

### Community 15 - "StatelessWidget"
Cohesion: 0.10
Nodes (23): build, buildSettingsMenuItem, buildSettingsMenuItemSwitcher, buildSettingsMenuItemWithDropMenu, children, icon, kicker, onChanged (+15 more)

### Community 16 - "package:flutter/material.dart"
Cohesion: 0.09
Nodes (17): customShowSnackBar, build, SignUpForm, build, ListForSavedArticles, build, SavedArticlesViewBody, build (+9 more)

### Community 17 - "auth_repo_impl.dart"
Cohesion: 0.10
Nodes (20): ../../../../core/params/signup_params.dart, ../../../../core/services/shared_preferences_singleton.dart, dart:convert, CacheHelper, cacheHelper, getUser, key, UserCacheDataSource (+12 more)

### Community 18 - "package:mind_feed/core/constants/app_images.dart"
Cohesion: 0.10
Nodes (17): build, Logo, build, DownloadedArticlesViewBody, build, FavoriteMoviesViewBody, ArticleViewBody, build (+9 more)

### Community 19 - "Mini-requirements"
Cohesion: 0.09
Nodes (21): 1. Mandatory Authentication & Onboarding, 2. Home Feed & Discovery, 3. Article Reader, Starring & Sharing, 4. Offline Mode (Text-Only), 5. Article Drafting, Preview, Publishing & Lifecycle, 6. Personal Collections & Settings, Acceptance Criteria, Business Rules (+13 more)

### Community 20 - "Continuation Packet: S1-editorial-shell-recovery"
Cohesion: 0.10
Nodes (19): Allowed edit scope, Areas that must not be redesigned, Completed work, Continuation objective, Continuation Packet: S1-editorial-shell-recovery, Current failures, Exact files to inspect, Exact remaining work (+11 more)

### Community 21 - "package:mind_feed/core/constants/app_colors.dart"
Cohesion: 0.11
Nodes (14): build, CustomLoadingIndecator, authBackground, build, ThereIsAnAccountText, AuthorPersonalInfo, build, _buildStatItem (+6 more)

### Community 22 - "package:mind_feed/core/constants/app_icons.dart"
Cohesion: 0.11
Nodes (15): build, MoreVertIcon, build, CustomPopupMenuButtonForSavedArticlesView, build, CustomPopupMenuButtonForHomeView, isDwonload, build (+7 more)

### Community 23 - "package:mind_feed/core/constants/app_text_styles.dart"
Cohesion: 0.10
Nodes (16): ArticleCardInformation, author, build, date, title, author, build, date (+8 more)

### Community 24 - "Task Packet: S1-editorial-shell"
Cohesion: 0.11
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 25 - "Task Packet: S2-auth-refinement"
Cohesion: 0.11
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 26 - "setup_service_locator.dart"
Cohesion: 0.12
Nodes (16): Connectivity, ../../features/auth/data/repos/auth_repo_impl.dart, Future, connectivity, isConnected, NetworkInfo, NetworkInfoImpl, getIt (+8 more)

### Community 27 - "api_result.dart"
Cohesion: 0.16
Nodes (16): Equatable, ../errors/failures.dart, CacheFailure, Failure, message, props, ServerFailure, ValidationFailure (+8 more)

### Community 28 - "editorial_design.dart"
Cohesion: 0.12
Nodes (17): authorName, build, _buildShareAction, createState, EditorialFollowButton, _EditorialFollowButtonState, EditorialIconButton, icon (+9 more)

### Community 29 - "package:mind_feed/core/constants/borders.dart"
Cohesion: 0.11
Nodes (14): build, buttonText, CustomButton, height, build, _buildRequirementRow, password, PasswordRequirements (+6 more)

### Community 30 - "auth_repo.dart"
Cohesion: 0.14
Nodes (15): AuthRepoImpl, AuthRepository, forgetPassword, login, signup, call, LoginUseCase, repo (+7 more)

### Community 31 - "device_preference_notifier.dart"
Cohesion: 0.12
Nodes (16): int get, copyWith, DevicePreferenceNotifier, DevicePreferences, hashCode, isDarkMode, isSplitLayout, loadDevicePreferences (+8 more)

### Community 32 - "article_card.dart"
Cohesion: 0.12
Nodes (16): ArticleCard, author, build, date, imagePath, isDwonload, isFav, title (+8 more)

### Community 33 - "borders.dart"
Cohesion: 0.12
Nodes (15): card, circular, control, l, m, _main, s, xl (+7 more)

### Community 34 - "editorial_models.dart"
Cohesion: 0.13
Nodes (14): Color, authorAvatar, authorName, authorRole, badge, badgeColor, color, excerpt (+6 more)

### Community 35 - "signup_view.dart"
Cohesion: 0.13
Nodes (13): ../controllers/signup_cubit/signup_cubit.dart, ../../data/repos/auth_repo_impl.dart, ../../domain/usecases/signup_use_case.dart, build, routeName, SignUpView, MethodChannel, package:flutter/services.dart (+5 more)

### Community 36 - "MindFeed Editorial UI Specification & Architecture"
Cohesion: 0.13
Nodes (14): 1. Visual Design Language (`lib/core/design/editorial_design.dart`), 2. Reusable Modular Components, 3. Screen Implementations, 4. Documentation & Verification Assets, 5. Automated Tests, Card Component (`lib/core/design/editorial_card.dart`), Data Models & Repository (`lib/core/design/editorial_models.dart`, `editorial_mock_data.dart`), Floating Editorial Navigation (`lib/features/main/presentation/widgets/main_navigation_bar.dart`) (+6 more)

### Community 37 - "package:mind_feed/config/routes/app_routes.dart"
Cohesion: 0.13
Nodes (12): build, ForgetPasswordText, ArticleCardOfAuthor, build, imagePath, isDwonload, isFav, title (+4 more)

### Community 38 - "next_button.dart"
Cohesion: 0.13
Nodes (12): build, currentPage, NextButton, pageController, build, OnBoardingBackground, pageController, build (+4 more)

### Community 39 - "settings_view_body.dart"
Cohesion: 0.15
Nodes (13): _bionicGuide, _breakingAlerts, _cachedMegabytes, createState, _dataPreservation, _fontScale, _morningBriefing, _serifMode (+5 more)

### Community 40 - "Mind Feed"
Cohesion: 0.14
Nodes (13): Architecture, Building APK, Features, Getting Started, Installation, Key Dependencies, License, Mind Feed (+5 more)

### Community 41 - "format_markdown.dart"
Cohesion: 0.15
Nodes (12): dart:math, convertToMarkdown, cursorIndex, data, FormatMarkdown, image, MarkdownType, replaceCursorIndex (+4 more)

### Community 42 - "sign_up_form_body.dart"
Cohesion: 0.17
Nodes (12): autovalidateMode, _confirmPasswordController, createState, dispose, _emailController, formKey, initState, _password (+4 more)

### Community 43 - "onboarding_view_body.dart"
Cohesion: 0.17
Nodes (12): build, createState, _currentPage, dispose, initState, OnboardingViewBody, _OnboardingViewBodyState, _pageController (+4 more)

### Community 44 - "check_code_view_body.dart"
Cohesion: 0.18
Nodes (11): AutovalidateMode, FormState, autovalidateMode, build, CheckCodeViewBody, _CheckCodeViewBodyState, createState, email (+3 more)

### Community 45 - "constants.dart"
Cohesion: 0.17
Nodes (11): AppConstants, appName, compact, page, roomy, supabaseAnonKey, supabaseUrl, themeModeKey (+3 more)

### Community 46 - "State"
Cohesion: 0.20
Nodes (11): EditorialSavedStack, _EditorialSavedStackState, build, category, CategoryCard, _CategoryCardState, createState, isSelected (+3 more)

### Community 47 - "auth_api_source.dart"
Cohesion: 0.17
Nodes (11): _client, currentUser, login, onAuthStateChange, resetPassword, signInWithGoogle, signOut, signUp (+3 more)

### Community 48 - "change_password_form.dart"
Cohesion: 0.18
Nodes (11): autovalidateMode, build, ChangePasswordForm, _ChangePasswordFormState, confirmPassword, createState, email, formKey (+3 more)

### Community 49 - "downloaded_articles_view.dart"
Cohesion: 0.18
Nodes (10): build, DownloadedArticlesView, routeName, build, FavoriteMoviesView, routeName, package:mind_feed/features/collections/presentation/widgets/downloaded_articles_view_body.dart, package:mind_feed/features/collections/presentation/widgets/favorite_movies_view_body.dart (+2 more)

### Community 50 - "aricles_by_categories.dart"
Cohesion: 0.17
Nodes (9): build, CustomSliverAppBarForArticlesSaved, build, ChipGroup, AriclesByCategories, build, package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart, package:mind_feed/features/auth/presentation/widgets/categories_view_body.dart (+1 more)

### Community 51 - "custom_drawer.dart"
Cohesion: 0.17
Nodes (11): build, CustomDrawer, routeName, build, package:flutter_svg/flutter_svg.dart, package:mind_feed/features/collections/presentation/views/downloaded_articles_view.dart, package:mind_feed/features/collections/presentation/views/favorite_movies_view.dart, package:mind_feed/features/settings/presentation/views/settings_view.dart (+3 more)

### Community 52 - "profile_remote_data_source.dart"
Cohesion: 0.18
Nodes (11): _client, getCategories, getFavoriteCategories, getProfile, ProfileRemoteDataSource, ProfileRemoteDataSourceImpl, setFavoriteCategories, _supabaseClient (+3 more)

### Community 53 - "login_cubit.dart"
Cohesion: 0.33
Nodes (10): errorMessage, LoginFailure, LoginInitial, LoginLoading, LoginState, LoginSuccess, eitherFailureOrLogin, LoginCubit (+2 more)

### Community 54 - "send_code_view_body.dart"
Cohesion: 0.20
Nodes (10): GlobalKey, autovalidateMode, build, createState, email, formKey, SendCodeViewBody, _SendCodeViewBodyState (+2 more)

### Community 55 - "main_navigation_bar.dart"
Cohesion: 0.18
Nodes (10): IconData, active, build, icon, label, MainNavigationBar, _Nav, onDestinationSelected (+2 more)

### Community 56 - "editorial_saved_stack.dart"
Cohesion: 0.18
Nodes (10): build, _buildDismissibleCard, createState, _deleteItem, didUpdateWidget, initState, items, onDeleteArticle (+2 more)

### Community 57 - "shared_preferences_singleton.dart"
Cohesion: 0.18
Nodes (10): clear, getBool, getString, init, _instance, remove, setBool, setString (+2 more)

### Community 58 - "login_form.dart"
Cohesion: 0.20
Nodes (10): autovalidateMode, build, createState, email, formKey, LoginForm, _LoginFormState, password (+2 more)

### Community 59 - "widget_test.dart"
Cohesion: 0.18
Nodes (9): build, ListSavedArticles, routeName, package:mind_feed/features/collections/presentation/views/articles_saved.dart, package:mind_feed/features/home/presentation/views/article_view.dart, package:mind_feed/features/main/presentation/views/main_view.dart, package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart, editorialHarness (+1 more)

### Community 60 - "article_view.dart"
Cohesion: 0.20
Nodes (10): _article, ArticleView, _ArticleViewState, build, createState, initState, _isLiked, _isSaved (+2 more)

### Community 61 - "MindFeed Editorial UI Transformation Plan"
Cohesion: 0.20
Nodes (9): Architecture decisions, Baseline evidence, Final validation, Goal, MindFeed Editorial UI Transformation Plan, Reference UI description, S1 — Editorial reading shell, S2 — Auth refinement (+1 more)

### Community 62 - "Hermes Review Result: S1-editorial-shell"
Cohesion: 0.20
Nodes (9): Executor evidence, Hermes Review Result: S1-editorial-shell, Independent validation, Recovery decision, Remaining failures or unverified claims, Requirement findings, Scope review, Security and safety (+1 more)

### Community 63 - "string_extension.dart"
Cohesion: 0.20
Nodes (9): capitalize, reversed, StringExtension, toDateTime, toDouble, toInt, toNum, String (+1 more)

### Community 64 - "profile_view.dart"
Cohesion: 0.20
Nodes (8): build, ProfileView, routeName, ArticlesCategoryView, build, routeName, package:mind_feed/features/profile/presentation/widget/profile_view_body.dart, static const

### Community 65 - "editorial_card.dart"
Cohesion: 0.22
Nodes (8): build, EditorialCard, item, onLike, onOpen, onSave, onShare, showActions

### Community 66 - "main_view.dart"
Cohesion: 0.25
Nodes (8): build, createState, MainView, _MainViewState, routeName, selectedIndex, package:mind_feed/features/main/presentation/widgets/main_navigation_bar.dart, package:mind_feed/features/search/presentation/views/search_view.dart

### Community 67 - "home_view.dart"
Cohesion: 0.25
Nodes (7): AdvancedDrawerController, advancedDrawerController, build, HomeView, routeName, package:flutter_advanced_drawer/flutter_advanced_drawer.dart, package:mind_feed/features/home/presentation/widgets/home_view_body.dart

### Community 68 - "package:flutter/foundation.dart"
Cohesion: 0.25
Nodes (7): Client, http.BaseClient, _inner, send, SupabaseInterceptor, package:flutter/foundation.dart, package:http/http.dart

### Community 69 - "Orchestration State"
Cohesion: 0.25
Nodes (7): Active file leases, Blockers and decisions, Last verified checkpoint, Milestones, Orchestration State, Project, Stage tracker

### Community 70 - "login_view.dart"
Cohesion: 0.25
Nodes (7): ../../domain/usecases/login_use_case.dart, build, LoginView, routeName, package:mind_feed/features/auth/data/repos/auth_repo_impl.dart, package:mind_feed/features/auth/presentation/controllers/login_cubit/login_cubit.dart, package:mind_feed/features/auth/presentation/widgets/login_view_body.dart

### Community 71 - "api_error_handler.dart"
Cohesion: 0.25
Nodes (7): ../errors/exceptions.dart, ApiErrorHandler, code, handle, message, toFailure, package:supabase_flutter/supabase_flutter.dart

### Community 72 - "signup_params.dart"
Cohesion: 0.25
Nodes (7): displayName, email, password, SignupParams, toJson, toSignUpJson, toUpdateDisplayNameJson

### Community 73 - "add_article.dart"
Cohesion: 0.25
Nodes (7): AddArticleView, build, MarkdownEditorApp, routeName, package:mind_feed/features/add_article/presentation/views/home_of_add_article_view.dart, package:mind_feed/features/add_article/presentation/widget/device_preference_notifier.dart, package:mind_feed/main.dart

### Community 74 - "List"
Cohesion: 0.25
Nodes (7): copyWith, email, favoriteCategories, token, userName, List, package:hive_flutter/adapters.dart

### Community 75 - "user_articles.dart"
Cohesion: 0.29
Nodes (7): _articles, build, createState, initState, UserArticles, _UserArticlesState, package:mind_feed/features/profile/presentation/widget/custom_article_card_of_profile.dart

### Community 76 - "custom_app_bar.dart"
Cohesion: 0.29
Nodes (6): AdvancedDrawerValue, build, CustomAppBar, _handleMenuButtonPressed, title, package:mind_feed/features/home/presentation/views/home_view.dart

### Community 77 - "Design Context"
Cohesion: 0.29
Nodes (6): Aesthetic Direction, Brand Personality, Design Context, Design Principles, Quality Bar, Users

### Community 78 - "package:mind_feed/core/design/editorial_models.dart"
Cohesion: 0.29
Nodes (6): EditorialMockData, savedStories, stories, userArticles, package:mind_feed/core/design/editorial_models.dart, static List

### Community 79 - "author_view.dart"
Cohesion: 0.29
Nodes (6): AuthorView, build, routeName, package:mind_feed/core/design/editorial_mock_data.dart, package:mind_feed/features/author/presentation/views/author_personal_info.dart, package:mind_feed/features/author/presentation/widgets/author_app_bar.dart

### Community 80 - "list_card.dart"
Cohesion: 0.29
Nodes (6): build, isleft, ListCard, listCardBody, package:mind_feed/features/collections/presentation/widgets/custom_popup_menu_button_for_saved_articles_view.dart, AppRoutes.listSavedArticles

### Community 81 - "Project Context: Mind Feed"
Cohesion: 0.33
Nodes (5): 1. Overview, 2. Architecture & Directory Structure, 3. Technology Stack & Key Libraries, 4. Recent Project Changes, Project Context: Mind Feed

### Community 82 - "custom_article_card_of_profile.dart"
Cohesion: 0.33
Nodes (5): EditorialNewsItem, CustomArticleCardOfProfile, item, onDelete, VoidCallback

### Community 83 - "categories_view_body.dart"
Cohesion: 0.33
Nodes (5): build, categories, CategoriesViewBody, package:mind_feed/core/widgets/custom_button.dart, package:mind_feed/features/auth/presentation/widgets/category_card.dart

### Community 84 - "add_to_favorite_article_card.dart"
Cohesion: 0.40
Nodes (5): AddToFavoriteArticleCard, _AddToFavoriteArticleCardState, build, createState, isFav

### Community 85 - "profile_view_body.dart"
Cohesion: 0.33
Nodes (5): build, ProfileViewBody, package:mind_feed/features/profile/presentation/widget/personal_infromation.dart, package:mind_feed/features/profile/presentation/widget/profile_app_bar.dart, package:mind_feed/features/profile/presentation/widget/user_articles.dart

### Community 86 - "Exception"
Cohesion: 0.60
Nodes (4): Exception, CacheException, NoInternetException, ServerException

### Community 87 - "login_params.dart"
Cohesion: 0.40
Nodes (4): email, LoginParams, password, toJson

### Community 88 - "no_account_text.dart"
Cohesion: 0.40
Nodes (4): build, NoAccountText, package:mind_feed/features/auth/presentation/views/signup_view.dart, SignUpView.routeName

## Knowledge Gaps
- **938 isolated node(s):** `almostBlack`, `amber`, `amberDark`, `amberDarker`, `black` (+933 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1107 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `UserEntity` connect `cache_helper.dart` to `List`, `main.dart`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._
- **Why does `AuthRepoImpl` connect `auth_repo.dart` to `auth_repo_impl.dart`, `setup_service_locator.dart`, `signup_view.dart`, `login_view.dart`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._
- **Why does `LoginCubit` connect `login_cubit.dart` to `signup_cubit.dart`, `main.dart`, `login_form.dart`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **What connects `almostBlack`, `amber`, `amberDark` to the rest of the system?**
  _938 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.01652892561983471 - nodes in this community are weakly interconnected._
- **Should `app_icons.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.02666666666666667 - nodes in this community are weakly interconnected._
- **Should `main.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.06294326241134751 - nodes in this community are weakly interconnected._