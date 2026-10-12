import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/add_article/presentation/views/add_article.dart';
import 'package:mind_feed/features/collections/presentation/views/list_saved_articles.dart';
import 'package:mind_feed/features/profile/presentation/views/profile_view.dart';
import 'package:mind_feed/features/home/presentation/views/article_view.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/presentation/views/categories_view.dart';
import 'package:mind_feed/features/auth/presentation/views/change_password_view.dart';
import 'package:mind_feed/features/auth/presentation/views/check_code_view.dart';
import 'package:mind_feed/features/auth/presentation/views/login_view.dart';
import 'package:mind_feed/features/auth/presentation/views/send_code_view.dart';
import 'package:mind_feed/features/auth/presentation/views/signup_view.dart';
import 'package:mind_feed/features/author/presentation/views/author_view.dart';
import 'package:mind_feed/features/collections/presentation/views/downloaded_articles_view.dart';
import 'package:mind_feed/features/collections/presentation/views/favorite_movies_view.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/main/presentation/views/main_view.dart';
import 'package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:mind_feed/features/search/presentation/views/articles_category_view.dart';
import 'package:mind_feed/features/search/presentation/views/search_view.dart';
import 'package:mind_feed/features/settings/presentation/views/settings_view.dart';
import 'package:mind_feed/features/splash/presentation/views/splash_view.dart';

sealed class AppRoutes {
  const AppRoutes();
  static void pop<T extends Object?>(
    final BuildContext context, [
    final T? result,
  ]) => Navigator.pop<T>(context);

  static Future<T?> _pushNamed<T extends Object?>(
    final BuildContext context,
    final String routeName, {
    final Object? arguments,
  }) => Navigator.pushNamed<T>(context, routeName, arguments: arguments);

  static Future<T?> _pushNamedAndRemoveAll<T extends Object?>(
    final BuildContext context,
    final String newRouteName, {
    final Object? arguments,
  }) => Navigator.pushNamedAndRemoveUntil<T>(
    context,
    newRouteName,
    (_) => false,
    arguments: arguments,
  );

  static Future<Object?> article(
    final BuildContext context, {
    final EditorialNewsItem? item,
  }) =>
      Navigator.of(context).push<Object>(createRoute(item: item));

  static Future<Object?> categoriesView(
    final BuildContext context, {
    required final UserEntity userEntity,
  }) => _pushNamed(context, CategoriesView.routeName, arguments: userEntity);

  static Future<Object?> checkCodeView(
    final BuildContext context, {
    required final String email,
  }) => _pushNamed(context, CheckCodeView.routeName, arguments: email);

  static Future<Object?> changepasswordView(
    final BuildContext context, {
    required final String email,
  }) => _pushNamed(context, ChangePasswordView.routeName, arguments: email);

  static Future<Object?> splash(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, SplashView.routeName);

  static Future<Object?> onboardingView(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, OnboardingView.routeName);

  static Future<Object?> login(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, LoginView.routeName);

  static Future<Object?> search(final BuildContext context) =>
      _pushNamed(context, SearchView.routeName);
  static Future<Object?> signup(final BuildContext context) =>
      _pushNamed(context, SignUpView.routeName);
  static Future<Object?> sendCode(final BuildContext context) =>
      _pushNamed(context, SendCodeView.routeName);
  static Future<Object?> home(final BuildContext context) =>
      _pushNamed(context, HomeView.routeName);
  static Future<Object?> main(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, MainView.routeName);
  static Future<Object?> articlesSaved(final BuildContext context) =>
      _pushNamed(context, ArticlesSaved.routeName);
  static Future<Object?> downloadedArticlesView(final BuildContext context) =>
      _pushNamed(context, DownloadedArticlesView.routeName);
  static Future<Object?> favoriteMoviesView(final BuildContext context) =>
      _pushNamed(context, FavoriteMoviesView.routeName);
  static Future<Object?> articleView(final BuildContext context) =>
      _pushNamed(context, ArticleView.routeName);
  static Future<Object?> authorView(final BuildContext context) =>
      _pushNamed(context, AuthorView.routeName);
  static Future<Object?> settingsView(final BuildContext context) =>
      _pushNamed(context, SettingsView.routeName);

  static Future<Object?> addArticleView(final BuildContext context) =>
      _pushNamed(context, AddArticleView.routeName);

  static Future<Object?> profileView(final BuildContext context) =>
      _pushNamed(context, ProfileView.routeName);

  static Future<Object?> listSavedArticles(final BuildContext context) =>
      _pushNamed(context, ListSavedArticles.routeName);

  static Future<Object?> articlesCategoryView(final BuildContext context) =>
      _pushNamed(context, ArticlesCategoryView.routeName);
}

class CreateNewPasswordViewArgs {
  const CreateNewPasswordViewArgs({required this.email, required this.code});
  final String email;
  final String code;
}

Map<String, Widget Function(BuildContext, Object?)> _routes = {
  '/': (_, _) => const SplashView(),
  SplashView.routeName: (_, _) => const SplashView(),
  OnboardingView.routeName: (_, _) => const OnboardingView(),
  LoginView.routeName: (_, _) => const LoginView(),
  SignUpView.routeName: (_, _) => const SignUpView(),
  SearchView.routeName: (_, _) => const SearchView(),
  SendCodeView.routeName: (_, _) => const SendCodeView(),
  HomeView.routeName: (_, _) => HomeView(),
  MainView.routeName: (_, _) => const MainView(),
  ArticlesSaved.routeName: (_, _) => const ArticlesSaved(),
  DownloadedArticlesView.routeName: (_, _) => const DownloadedArticlesView(),
  FavoriteMoviesView.routeName: (_, _) => const FavoriteMoviesView(),
  ArticleView.routeName: (_, final args) =>
      ArticleView(item: args is EditorialNewsItem ? args : null),
  AuthorView.routeName: (_, _) => const AuthorView(),
  SettingsView.routeName: (_, _) => const SettingsView(),
  AddArticleView.routeName: (_, _) => AddArticleView(),
  ProfileView.routeName: (_, _) => ProfileView(),
  ListSavedArticles.routeName: (_, _) => ListSavedArticles(),
  ArticlesCategoryView.routeName: (_, _) => ArticlesCategoryView(),

  CheckCodeView.routeName: (_, final args) =>
      CheckCodeView(email: args! as String),
  ChangePasswordView.routeName: (_, final args) =>
      ChangePasswordView(email: args! as String),
  CategoriesView.routeName: (_, final args) =>
      CategoriesView(userEntity: args! as UserEntity),
};

Route<dynamic>? Function(RouteSettings)? onGenerateRoute = (final settings) {
  final targetName = (settings.name == null || settings.name == '/')
      ? SplashView.routeName
      : settings.name;
  final builder =
      _routes[targetName] ??
      _routes[settings.name] ??
      (_, _) => const Scaffold(body: Center(child: Text('Page not found')));
  return MaterialPageRoute(
    builder: (final context) => builder(context, settings.arguments),
    settings: settings,
  );
};

Route<Object> createRoute({final EditorialNewsItem? item}) {
  return PageRouteBuilder<Object>(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ArticleView(item: item),
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
