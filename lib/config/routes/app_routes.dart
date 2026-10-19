import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/domain/entities/check_code_args.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/profile/presentation/views/categories_view.dart';
import 'package:mind_feed/features/profile/presentation/controllers/categories_cubit/categories_cubit.dart';
import 'package:mind_feed/features/main/presentation/controllers/main_shell_cubit/main_shell_cubit.dart';
import 'package:mind_feed/features/auth/presentation/views/change_password_view.dart';
import 'package:mind_feed/features/auth/presentation/views/check_code_view.dart';
import 'package:mind_feed/features/auth/presentation/views/login_view.dart';
import 'package:mind_feed/features/auth/presentation/views/send_code_view.dart';
import 'package:mind_feed/features/auth/presentation/views/signup_view.dart';
import 'package:mind_feed/features/author/domain/entities/author_profile_args.dart';
import 'package:mind_feed/features/author/presentation/views/author_view.dart';
import 'package:mind_feed/features/search/presentation/views/tag_articles_view.dart';
import 'package:mind_feed/features/collections/presentation/views/downloaded_articles_view.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/collections/presentation/views/list_saved_articles.dart';
import 'package:mind_feed/features/article/presentation/views/article_view.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/main/presentation/views/main_view.dart';
import 'package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:mind_feed/features/search/presentation/views/articles_category_view.dart';
import 'package:mind_feed/features/search/presentation/views/search_view.dart';
import 'package:mind_feed/features/settings/presentation/views/settings_view.dart';
import 'package:mind_feed/features/add_article/presentation/views/add_article.dart';
import 'package:mind_feed/features/add_article/presentation/views/article_preview_view.dart';
import 'package:mind_feed/features/add_article/presentation/views/drafts_view.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/drafts_cubit/drafts_cubit.dart';
import 'package:mind_feed/features/profile/presentation/views/profile_view.dart';
import 'package:mind_feed/features/splash/presentation/views/splash_view.dart';

sealed class AppRoutes {
  static const String main = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String search = '/search';
  static const String sendCode = '/send-code';
  static const String home = '/home';
  static const String articlesSaved = '/articles-saved';
  static const String downloadedArticles = '/downloaded-articles';
  static const String article = '/article';
  static const String author = '/author';
  static const String settings = '/settings';
  static const String addArticle = '/add-article';
  static const String profile = '/profile';
  static const String listSavedArticles = '/list-saved-articles';
  static const String articlesCategory = '/articles-category';
  static const String checkCode = '/check-code';
  static const String changePassword = '/change-password';
  static const String categories = '/categories';
  static const String drafts = '/drafts';
  static const String articlePreview = '/article-preview';
  static const String tagArticles = '/tag-articles';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView(), settings: settings);
      case AppRoutes.main:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<MainShellCubit>()..onShellStarted(),
            child: const MainView(),
          ),
          settings: settings,
        );
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView(), settings: settings);
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView(), settings: settings);
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignUpView(), settings: settings);
      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchView(), settings: settings);
      case AppRoutes.sendCode:
        return MaterialPageRoute(builder: (_) => const SendCodeView(), settings: settings);
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeView(), settings: settings);
      case AppRoutes.articlesSaved:
        return MaterialPageRoute(builder: (_) => const ArticlesSaved(), settings: settings);
      case AppRoutes.downloadedArticles:
        return MaterialPageRoute(builder: (_) => const DownloadedArticlesView(), settings: settings);
      case AppRoutes.article:
        final args = settings.arguments as EditorialNewsItem?;
        return _createArticleRoute(item: args, settings: settings);
      case AppRoutes.author:
        final authorArgs = settings.arguments;
        if (authorArgs is AuthorProfileArgs) {
          return MaterialPageRoute(
            builder: (_) => AuthorView(
              authorName: authorArgs.authorName,
              authorRole: authorArgs.authorRole,
              authorAvatar: authorArgs.authorAvatar,
              authorId: authorArgs.authorId,
            ),
            settings: settings,
          );
        }
        if (authorArgs is EditorialNewsItem) {
          return MaterialPageRoute(
            builder: (_) => AuthorView(
              authorName: authorArgs.authorName,
              authorRole: authorArgs.authorRole,
              authorAvatar: authorArgs.authorAvatar,
              authorId: authorArgs.authorId,
            ),
            settings: settings,
          );
        }
        if (authorArgs is String && authorArgs.trim().isNotEmpty) {
          return MaterialPageRoute(
            builder: (_) => AuthorView(authorName: authorArgs.trim()),
            settings: settings,
          );
        }
        return MaterialPageRoute(builder: (_) => const AuthorView(), settings: settings);
      case AppRoutes.tagArticles:
        final tag = settings.arguments is String ? (settings.arguments as String).trim() : '';
        return MaterialPageRoute(
          builder: (_) => TagArticlesView(tag: tag),
          settings: settings,
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<SettingsCubit>()..loadSettings(),
            child: const SettingsView(),
          ),
          settings: settings,
        );
      case AppRoutes.addArticle:
        final item = settings.arguments as EditorialNewsItem?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AddArticleCubit>()..initialize(editingItem: item),
            child: AddArticleView(initialItem: item),
          ),
          settings: settings,
        );
      case AppRoutes.drafts:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<DraftsCubit>()..loadDrafts(),
            child: const DraftsView(),
          ),
          settings: settings,
        );
      case AppRoutes.articlePreview:
        final item = settings.arguments as EditorialNewsItem?;
        return MaterialPageRoute(
          builder: (_) => ArticlePreviewView(item: item),
          settings: settings,
        );
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => ProfileView(), settings: settings);
      case AppRoutes.listSavedArticles:
        return MaterialPageRoute(builder: (_) => ListSavedArticles(), settings: settings);
      case AppRoutes.articlesCategory:
        return MaterialPageRoute(builder: (_) => ArticlesCategoryView(), settings: settings);
      case AppRoutes.checkCode:
        final args = settings.arguments;
        final String email;
        final bool isPasswordReset;
        if (args is CheckCodeArgs) {
          email = args.email;
          isPasswordReset = args.isPasswordReset;
        } else if (args is Map<String, dynamic>) {
          email = args['email'] as String? ?? '';
          isPasswordReset = args['isPasswordReset'] as bool? ?? false;
        } else {
          email = args as String;
          isPasswordReset = false;
        }
        return MaterialPageRoute(
          builder: (_) => CheckCodeView(
            email: email,
            isPasswordReset: isPasswordReset,
          ),
          settings: settings,
        );
      case AppRoutes.changePassword:
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ChangePasswordView(email: email), settings: settings);
      case AppRoutes.categories:
        final user = settings.arguments as UserEntity?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) {
              final cubit = getIt<CategoriesCubit>();
              if (user?.favoriteCategories != null && user!.favoriteCategories!.isNotEmpty) {
                cubit.initialize(user.favoriteCategories!);
              }
              return cubit;
            },
            child: CategoriesView(userEntity: user),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Page not found'))), settings: settings);
    }
  }


  static Route<Object> _createArticleRoute({EditorialNewsItem? item, RouteSettings? settings}) {
    return PageRouteBuilder<Object>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => ArticleView(item: item),
      transitionDuration: const Duration(milliseconds: 550),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.easeInCubic,
        );
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.16),
          end: Offset.zero,
        ).animate(curvedAnimation);
        final scaleAnimation = Tween<double>(
          begin: 0.88,
          end: 1.0,
        ).animate(curvedAnimation);
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
