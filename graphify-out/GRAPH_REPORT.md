# Graph Report - mind_feed  (2026-10-13)

## Corpus Check
- 171 files · ~200,497 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1713 nodes · 2502 edges · 103 communities (86 shown, 17 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 125 edges (avg confidence: 0.73)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Color Palette & Palette Constants
- Iconography & System Icons
- Supabase Client & HTTP Interceptor
- Local Storage & Hive Cache
- Authentication State & Login Cubit
- Brand Media & Category Visuals
- Startup Routing & Splash Flow
- Article Creation & Publishing Cubit
- Asset Paths & Image Constants
- Theme Components & UI Styling
- App Routes & Navigation Registry
- Project Context & Architecture Specs
- Dynamic Theming & Theme Mode Config
- Navigation Drawer & App Bar Components
- Markdown Editor & Input Actions
- Border Geometry & Surface Radius
- Registration Forms & User Feedback
- Custom Form Fields & Text Inputs
- Business Requirements & Product KPIs
- Article Editor & Content Scaffold
- Article Card Information Module
- Editorial Card Stack Module
- Article Card Module
- Settings Menu Module
- Onboarding View Body Module
- Author Personal Info Module
- S1-Editorial-Shell-Recovery Module
- Custom Popup Menu Button For Home Module
- Sign Up Form Body Module
- S1-Editorial-Shell Module
- S2-Auth-Refinement Module
- Login View Module
- Network Info Module
- Editorial Design Module
- Custom Button Module
- Auth Repo Module
- Login Form Module
- Send Code View Body Module
- Main Module
- Settings View Body Module
- Readme Module
- Auth Repo Impl Module
- Editorial Saved Stack Module
- Auth Api Source Module
- Login View Body Module
- Format Markdown Module
- Change Password Form Module
- Profile Remote Data Source Module
- Home View Body Module
- Main Navigation Bar Module
- Change Password View Body Module
- Forget Password Text Module
- Article View Module
- Splash Logo Widget Module
- Signup State Module
- Plan Module
- S1-Editorial-Shell-Review Module
- Failures Module
- Password Text Field Module
- Change Password Form Module
- Theme Mode State Module
- Skip Button Module
- Api Result Module
- User Entity Module
- Editorial Card Module
- State Module
- Api Error Handler Module
- String Extension Module
- Signup Params Module
- Category Card Module
- User Articles Module
- .Impeccable Module
- Editorial Mock Data Module
- Author View Module
- Article Card Of Author Module
- List Card Module
- Profile App Bar Module
- Main View Module
- Custom Article Card Of Profile Module
- Categories View Body Module
- Add To Favorite Article Card Module
- Custom Drawer Module
- Page View Item Module
- Profile View Body Module
- Widget Test Module
- Exceptions Module
- Personalize Graphify Module
- Login Params Module
- No Account Text Module
- List Saved Articles Module
- Saved Articles View Body Module
- Article Card Module
- Next Button Module
- Custom Loading Indecator Module
- Check Code View Body Module
- Analysis Options Module

## God Nodes (most connected - your core abstractions)
1. `MindFeed Editorial UI Specification & Architecture` - 36 edges
2. `Continuation Packet: S1-editorial-shell-recovery` - 19 edges
3. `Mini-requirements` - 18 edges
4. `Task Packet: S1-editorial-shell` - 18 edges
5. `Task Packet: S2-auth-refinement` - 18 edges
6. `Project Context: Mind Feed` - 12 edges
7. `AddArticleCubit` - 12 edges
8. `LoginCubit` - 10 edges
9. `SignupCubit` - 10 edges
10. `ThemeModeCubit` - 10 edges

## Surprising Connections (you probably didn't know these)
- `Category Icon: Business Icon` --conceptually_related_to--> `MindFeed Editorial UI Specification & Architecture`  [INFERRED]
  assets/images/Business_Icon.svg → docs/UI_SPECIFICATION.md
- `Category Icon: Education Icon` --conceptually_related_to--> `MindFeed Editorial UI Specification & Architecture`  [INFERRED]
  assets/images/Education_Icon.svg → docs/UI_SPECIFICATION.md
- `Visual Asset: Justtest` --conceptually_related_to--> `MindFeed Editorial UI Specification & Architecture`  [INFERRED]
  assets/images/justTest.webp → docs/UI_SPECIFICATION.md
- `Brand Asset: Mindfeedlogo` --conceptually_related_to--> `MindFeed Editorial UI Specification & Architecture`  [INFERRED]
  assets/images/MindFeedLogo.png → docs/UI_SPECIFICATION.md
- `Visual Asset: Mit News Ai Coding` --conceptually_related_to--> `MindFeed Editorial UI Specification & Architecture`  [INFERRED]
  assets/images/MIT_News-AI_coding.png → docs/UI_SPECIFICATION.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **MindFeed Core Specification & Governance Suite** — brd_business_requirements_document_brd, spec_mind_feed_core_application, context_project_context_mind_feed, docs_ui_specification_mindfeed_editorial_ui_specification_architecture [INFERRED 0.85]

## Communities (103 total, 17 thin omitted)

### Community 0 - "Color Palette & Palette Constants"
Cohesion: 0.02
Nodes (117): almostBlack, amber, amberDark, amberDarker, black, blue, blueMain, blush (+109 more)

### Community 1 - "Iconography & System Icons"
Cohesion: 0.03
Nodes (73): add, alternateEmailRounded, AppIcons, arrowBackRounded, arrowForwardIosRounded, articleOutlined, boltRounded, bookmark (+65 more)

### Community 2 - "Supabase Client & HTTP Interceptor"
Cohesion: 0.05
Nodes (39): _inner, send, SupabaseInterceptor, _allStories, CollectionsCubit, deleteArticle, loadSavedStories, searchStories (+31 more)

### Community 3 - "Local Storage & Hive Cache"
Cohesion: 0.04
Nodes (34): box, CacheHelper, clearData, containsKey, getData, getDataFromHive, getDataString, kBoxName (+26 more)

### Community 4 - "Authentication State & Login Cubit"
Cohesion: 0.05
Nodes (34): errorMessage, LoginFailure, LoginInitial, LoginLoading, LoginState, LoginSuccess, AppThemeData, ThemeConfig (+26 more)

### Community 5 - "Brand Media & Category Visuals"
Cohesion: 0.05
Nodes (42): Category Icon: Business Icon, Category Icon: Education Icon, Visual Asset: Justtest, Brand Asset: Mindfeedlogo, Visual Asset: Mit News Ai Coding, Onboarding Visual: Onboarding 1, Onboarding Visual: Onboarding 2, Onboarding Visual: Onboarding 3 (+34 more)

### Community 6 - "Startup Routing & Splash Flow"
Cohesion: 0.06
Nodes (22): StartupDestination, StartupLogin, StartupMain, StartupOnboarding, _checkAppStartupUseCase, initApp, _minDisplayDuration, SplashCubit (+14 more)

### Community 7 - "Article Creation & Publishing Cubit"
Cohesion: 0.07
Nodes (34): AddArticleCubit, clearText, _currentFileName, openFile, saveFile, build, _clearText, createState (+26 more)

### Community 8 - "Asset Paths & Image Constants"
Cohesion: 0.05
Nodes (30): Assets, assetsImagesBusinessIcon, assetsImagesEducationIcon, assetsImagesJustTest, assetsImagesMindFeedLogo, assetsImagesMITNewsAICoding, assetsImagesOnBoarding1, assetsImagesOnBoarding2 (+22 more)

### Community 9 - "Theme Components & UI Styling"
Cohesion: 0.05
Nodes (22): card, checkbox, chip, dialog, dropdownMenu, filledButton, floatingActionButton, iconButton (+14 more)

### Community 10 - "App Routes & Navigation Registry"
Cohesion: 0.05
Nodes (24): addArticle, AppRoutes, article, articlesCategory, articlesSaved, author, categories, changePassword (+16 more)

### Community 11 - "Project Context & Architecture Specs"
Cohesion: 0.08
Nodes (31): 1. Overview, 2. Architecture & Directory Structure, 3. Technology Stack & Key Libraries, 4. Recent Project Changes, Architecture & Directory Layout, Project Context: Mind Feed, Project Documentation Authority, Project Summary (+23 more)

### Community 12 - "Dynamic Theming & Theme Mode Config"
Cohesion: 0.06
Nodes (23): dark, dynamicSchemeVariant, isAmoledSelected, light, platform, seedColor, SettingsEntity, _themeData (+15 more)

### Community 13 - "Navigation Drawer & App Bar Components"
Cohesion: 0.08
Nodes (15): build, CustomAppBar, _handleMenuButtonPressed, title, authBackground, build, DownloadedArticlesView, routeName (+7 more)

### Community 14 - "Markdown Editor & Input Actions"
Cohesion: 0.07
Nodes (21): actions, actionWidget, _basicInkwell, build, controller, _controllerListener, createState, dispose (+13 more)

### Community 15 - "Border Geometry & Surface Radius"
Cohesion: 0.07
Nodes (24): card, circular, control, l, m, _main, s, xl (+16 more)

### Community 16 - "Registration Forms & User Feedback"
Cohesion: 0.07
Nodes (16): customShowSnackBar, build, SignUpForm, build, ThereIsAnAccountText, build, ListForSavedArticles, build (+8 more)

### Community 17 - "Custom Form Fields & Text Inputs"
Cohesion: 0.08
Nodes (20): build, CustomTextField, hintText, keyboardType, obscureText, onChanged, prefixIcon, suffixIcon (+12 more)

### Community 18 - "Business Requirements & Product KPIs"
Cohesion: 0.10
Nodes (24): 1.1 Purpose, 1.2 Business Problem Statement, 1.3 Vision & Solution, 1. Executive Summary, 2. Business Objectives & Key Performance Indicators (KPIs), 3.1 Competitive Landscape, 3.2 Target Audience Segments, 3. Market Analysis & Value Proposition (+16 more)

### Community 19 - "Article Editor & Content Scaffold"
Cohesion: 0.08
Nodes (17): AddArticleView, build, MarkdownEditorApp, routeName, copyWith, DevicePreferenceNotifier, DevicePreferences, hashCode (+9 more)

### Community 20 - "Article Card Information Module"
Cohesion: 0.08
Nodes (16): ArticleCardInformation, author, build, date, title, author, build, date (+8 more)

### Community 21 - "Editorial Card Stack Module"
Cohesion: 0.09
Nodes (20): _animController, build, _cards, createState, didUpdateWidget, dispose, _dragOffset, EditorialCardStack (+12 more)

### Community 22 - "Article Card Module"
Cohesion: 0.08
Nodes (13): build, CustomSliverAppBarForArticlesSaved, ArticleCard, author, date, imagePath, isDwonload, isFav (+5 more)

### Community 23 - "Settings Menu Module"
Cohesion: 0.10
Nodes (22): build, buildSettingsMenuItem, buildSettingsMenuItemSwitcher, buildSettingsMenuItemWithDropMenu, children, icon, kicker, onChanged (+14 more)

### Community 24 - "Onboarding View Body Module"
Cohesion: 0.09
Nodes (14): build, OnBoardingBackground, pageController, build, OnBoardingPageView, pageController, build, createState (+6 more)

### Community 25 - "Author Personal Info Module"
Cohesion: 0.10
Nodes (12): build, Logo, AuthorPersonalInfo, build, _buildStatItem, build, DownloadedArticlesViewBody, build (+4 more)

### Community 26 - "S1-Editorial-Shell-Recovery Module"
Cohesion: 0.19
Nodes (19): Allowed edit scope, Areas that must not be redesigned, Completed work, Continuation objective, Continuation Packet: S1-editorial-shell-recovery, Current failures, Exact files to inspect, Exact remaining work (+11 more)

### Community 27 - "Custom Popup Menu Button For Home Module"
Cohesion: 0.11
Nodes (13): build, MoreVertIcon, build, CustomPopupMenuButtonForSavedArticlesView, build, CustomPopupMenuButtonForHomeView, isDwonload, build (+5 more)

### Community 28 - "Sign Up Form Body Module"
Cohesion: 0.12
Nodes (15): SignupCubit, autovalidateMode, build, _confirmPasswordController, createState, dispose, _emailController, formKey (+7 more)

### Community 29 - "S1-Editorial-Shell Module"
Cohesion: 0.20
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 30 - "S2-Auth-Refinement Module"
Cohesion: 0.20
Nodes (18): Acceptance criteria, Allowed edit scope, Current project state, Exact broader validation commands, Exact focused test commands, Exact repository path, Files or systems that must not be modified, Implementation requirements (+10 more)

### Community 31 - "Login View Module"
Cohesion: 0.12
Nodes (7): AuthRepoImpl, build, LoginView, routeName, build, routeName, SignUpView

### Community 32 - "Network Info Module"
Cohesion: 0.12
Nodes (6): connectivity, isConnected, NetworkInfo, NetworkInfoImpl, getIt, setupServiceLocator

### Community 33 - "Editorial Design Module"
Cohesion: 0.12
Nodes (17): authorName, build, _buildShareAction, createState, EditorialFollowButton, _EditorialFollowButtonState, EditorialIconButton, icon (+9 more)

### Community 34 - "Custom Button Module"
Cohesion: 0.11
Nodes (13): build, buttonText, CustomButton, height, build, _buildRequirementRow, password, PasswordRequirements (+5 more)

### Community 35 - "Auth Repo Module"
Cohesion: 0.15
Nodes (9): AuthRepository, forgetPassword, login, signup, call, LoginUseCase, repo, call (+1 more)

### Community 36 - "Login Form Module"
Cohesion: 0.14
Nodes (10): LoginCubit, autovalidateMode, build, createState, email, formKey, LoginForm, _LoginFormState (+2 more)

### Community 37 - "Send Code View Body Module"
Cohesion: 0.14
Nodes (9): autovalidateMode, createState, email, formKey, autovalidateMode, build, createState, email (+1 more)

### Community 38 - "Main Module"
Cohesion: 0.12
Nodes (7): globalDevicePreferenceNotifier, init, initFlutter, loadDevicePreferences, main, channel, main

### Community 39 - "Settings View Body Module"
Cohesion: 0.15
Nodes (11): _bionicGuide, _breakingAlerts, _cachedMegabytes, createState, _dataPreservation, _fontScale, _morningBriefing, _serifMode (+3 more)

### Community 40 - "Readme Module"
Cohesion: 0.22
Nodes (13): Architecture, Building APK, Features, Getting Started, Installation, Key Dependencies, License, Mind Feed (+5 more)

### Community 41 - "Auth Repo Impl Module"
Cohesion: 0.15
Nodes (7): authApiSource, cacheHelper, forgetPassword, login, networkInfo, signup, userCacheDataSource

### Community 42 - "Editorial Saved Stack Module"
Cohesion: 0.17
Nodes (12): build, _buildDismissibleCard, createState, _deleteItem, didUpdateWidget, EditorialSavedStack, _EditorialSavedStackState, initState (+4 more)

### Community 43 - "Auth Api Source Module"
Cohesion: 0.15
Nodes (10): AuthApiSource, _client, currentUser, login, onAuthStateChange, resetPassword, signInWithGoogle, signOut (+2 more)

### Community 45 - "Format Markdown Module"
Cohesion: 0.17
Nodes (9): convertToMarkdown, cursorIndex, data, FormatMarkdown, image, MarkdownType, replaceCursorIndex, ResultMarkdown (+1 more)

### Community 46 - "Change Password Form Module"
Cohesion: 0.23
Nodes (10): ChangePasswordForm, _ChangePasswordFormState, CheckCodeViewBody, _CheckCodeViewBodyState, PasswordTextField, _PasswordTextFieldState, SendCodeViewBody, _SendCodeViewBodyState (+2 more)

### Community 47 - "Profile Remote Data Source Module"
Cohesion: 0.18
Nodes (9): _client, getCategories, getFavoriteCategories, getProfile, ProfileRemoteDataSource, ProfileRemoteDataSourceImpl, setFavoriteCategories, _supabaseClient (+1 more)

### Community 48 - "Home View Body Module"
Cohesion: 0.20
Nodes (9): _breathingAnimation, _breathingController, createState, dispose, HomeViewBody, _HomeViewBodyState, initState, _selectedTopic (+1 more)

### Community 49 - "Main Navigation Bar Module"
Cohesion: 0.18
Nodes (9): active, build, icon, label, MainNavigationBar, _Nav, onDestinationSelected, onTap (+1 more)

### Community 50 - "Change Password View Body Module"
Cohesion: 0.18
Nodes (5): build, ChangePasswordViewBody, email, AuthorAppBar, build

### Community 51 - "Forget Password Text Module"
Cohesion: 0.18
Nodes (4): build, ForgetPasswordText, build, MyApp

### Community 52 - "Article View Module"
Cohesion: 0.20
Nodes (10): _article, ArticleView, _ArticleViewState, build, createState, initState, _isLiked, _isSaved (+2 more)

### Community 53 - "Splash Logo Widget Module"
Cohesion: 0.22
Nodes (8): _breathingAnimation, _breathingController, build, createState, dispose, initState, SplashLogoWidget, _SplashLogoWidgetState

### Community 54 - "Signup State Module"
Cohesion: 0.29
Nodes (8): errorMessage, SignupFailure, SignupInitial, SignupLoading, SignupState, SignupSuccess, eitherFailureOrSignup, signUpUseCase

### Community 55 - "Plan Module"
Cohesion: 0.31
Nodes (9): Architecture decisions, Baseline evidence, Final validation, Goal, MindFeed Editorial UI Transformation Plan, Reference UI description, S1 — Editorial reading shell, S2 — Auth refinement (+1 more)

### Community 56 - "S1-Editorial-Shell-Review Module"
Cohesion: 0.36
Nodes (9): Executor evidence, Hermes Review Result: S1-editorial-shell, Independent validation, Recovery decision, Remaining failures or unverified claims, Requirement findings, Scope review, Security and safety (+1 more)

### Community 57 - "Failures Module"
Cohesion: 0.27
Nodes (6): CacheFailure, Failure, message, props, ServerFailure, ValidationFailure

### Community 58 - "Password Text Field Module"
Cohesion: 0.20
Nodes (8): build, controller, createState, dispose, hintText, _isObscured, onChanged, _passwordFocusNode

### Community 59 - "Change Password Form Module"
Cohesion: 0.20
Nodes (7): autovalidateMode, build, confirmPassword, createState, email, formKey, password

### Community 60 - "Theme Mode State Module"
Cohesion: 0.33
Nodes (7): ThemeModeDark, ThemeModeInitial, ThemeModeLight, ThemeModeState, ThemeModeSystem, changeThemeMode, getThemeMode

### Community 61 - "Skip Button Module"
Cohesion: 0.25
Nodes (4): build, SkipButton, call, CheckAppStartupUseCase

### Community 62 - "Api Result Module"
Cohesion: 0.33
Nodes (5): ApiResult, data, failure, FailureResult, Success

### Community 63 - "User Entity Module"
Cohesion: 0.22
Nodes (6): StringExtension, copyWith, email, favoriteCategories, token, userName

### Community 64 - "Editorial Card Module"
Cohesion: 0.22
Nodes (8): build, EditorialCard, item, onLike, onOpen, onSave, onShare, showActions

### Community 65 - "State Module"
Cohesion: 0.43
Nodes (7): Active file leases, Blockers and decisions, Last verified checkpoint, Milestones, Orchestration State, Project, Stage tracker

### Community 66 - "Api Error Handler Module"
Cohesion: 0.25
Nodes (5): ApiErrorHandler, code, handle, message, toFailure

### Community 67 - "String Extension Module"
Cohesion: 0.25
Nodes (6): capitalize, reversed, toDateTime, toDouble, toInt, toNum

### Community 68 - "Signup Params Module"
Cohesion: 0.25
Nodes (7): displayName, email, password, SignupParams, toJson, toSignUpJson, toUpdateDisplayNameJson

### Community 69 - "Category Card Module"
Cohesion: 0.29
Nodes (6): build, category, CategoryCard, _CategoryCardState, createState, isSelected

### Community 70 - "User Articles Module"
Cohesion: 0.29
Nodes (6): _articles, build, createState, initState, UserArticles, _UserArticlesState

### Community 71 - ".Impeccable Module"
Cohesion: 0.29
Nodes (6): Aesthetic Direction, Brand Personality, Design Context, Design Principles, Quality Bar, Users

### Community 72 - "Editorial Mock Data Module"
Cohesion: 0.29
Nodes (4): EditorialMockData, savedStories, stories, userArticles

### Community 73 - "Author View Module"
Cohesion: 0.29
Nodes (3): AuthorView, build, routeName

### Community 74 - "Article Card Of Author Module"
Cohesion: 0.29
Nodes (6): ArticleCardOfAuthor, build, imagePath, isDwonload, isFav, title

### Community 75 - "List Card Module"
Cohesion: 0.29
Nodes (4): build, isleft, ListCard, listCardBody

### Community 76 - "Profile App Bar Module"
Cohesion: 0.29
Nodes (3): build, build, ProfileAppBar

### Community 77 - "Main View Module"
Cohesion: 0.29
Nodes (4): build, createState, routeName, selectedIndex

### Community 78 - "Custom Article Card Of Profile Module"
Cohesion: 0.33
Nodes (3): CustomArticleCardOfProfile, item, onDelete

### Community 79 - "Categories View Body Module"
Cohesion: 0.33
Nodes (3): build, categories, CategoriesViewBody

### Community 80 - "Add To Favorite Article Card Module"
Cohesion: 0.40
Nodes (5): AddToFavoriteArticleCard, _AddToFavoriteArticleCardState, build, createState, isFav

### Community 82 - "Page View Item Module"
Cohesion: 0.33
Nodes (4): build, description, PageViewItem, title

### Community 85 - "Exceptions Module"
Cohesion: 0.60
Nodes (3): CacheException, NoInternetException, ServerException

### Community 87 - "Login Params Module"
Cohesion: 0.40
Nodes (4): email, LoginParams, password, toJson

### Community 89 - "List Saved Articles Module"
Cohesion: 0.40
Nodes (3): build, ListSavedArticles, routeName

### Community 91 - "Article Card Module"
Cohesion: 0.40
Nodes (3): build, build, build

### Community 92 - "Next Button Module"
Cohesion: 0.40
Nodes (4): build, currentPage, NextButton, pageController

## Knowledge Gaps
- **839 isolated node(s):** `card`, `checkbox`, `chip`, `dialog`, `dropdownMenu` (+834 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1092 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **17 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AddArticleCubit` connect `Article Creation & Publishing Cubit` to `Supabase Client & HTTP Interceptor`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Are the 29 inferred relationships involving `MindFeed Editorial UI Specification & Architecture` (e.g. with `Category Icon: Business Icon` and `Category Icon: Education Icon`) actually correct?**
  _`MindFeed Editorial UI Specification & Architecture` has 29 INFERRED edges - model-reasoned connections that need verification._
- **What connects `card`, `checkbox`, `chip` to the rest of the system?**
  _839 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Color Palette & Palette Constants` be split into smaller, more focused modules?**
  _Cohesion score 0.01652892561983471 - nodes in this community are weakly interconnected._
- **Should `Iconography & System Icons` be split into smaller, more focused modules?**
  _Cohesion score 0.02666666666666667 - nodes in this community are weakly interconnected._
- **Should `Supabase Client & HTTP Interceptor` be split into smaller, more focused modules?**
  _Cohesion score 0.052600818234950324 - nodes in this community are weakly interconnected._
- **Should `Local Storage & Hive Cache` be split into smaller, more focused modules?**
  _Cohesion score 0.04336734693877551 - nodes in this community are weakly interconnected._