import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/presentation/views/login_view.dart';
import 'package:mind_feed/features/auth/presentation/views/signup_view.dart';
import 'package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart';

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

  // Routes with arguments

  // static Future<Object?> createNewPasswordView(
  //   final BuildContext context, {
  //   required final String email,
  //   required final String code,
  // }) => _pushNamed(
  //   context,
  //   CreateNewPasswordView.routeName,
  //   arguments: CreateNewPasswordViewArgs(email: email, code: code),
  // );

  // static Future<Object?> rayResultsPatientDashboard(
  //   final BuildContext context, {
  //   required final List<RayEntity> rays,
  // }) => _pushNamed(
  //   context,
  //   RayResultsPatientDashboard.routeName,
  //   arguments: rays,
  // );

  // Routes without arguments
  static Future<Object?> onboardingView(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, OnboardingView.routeName);

  static Future<Object?> login(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, LoginView.routeName);
  static Future<Object?> signup(final BuildContext context) =>
      _pushNamed(context, SignUpView.routeName);
}

class CreateNewPasswordViewArgs {
  const CreateNewPasswordViewArgs({required this.email, required this.code});
  final String email;
  final String code;
}

Map<String, Widget Function(BuildContext, Object?)> _routes = {
  OnboardingView.routeName: (_, _) => const OnboardingView(),
  LoginView.routeName: (_, _) => const LoginView(),
  SignUpView.routeName: (_, _) => const SignUpView(),

  // MainView.routeName: (_, _) => const MainView(),
  // PatientInformation.routeName: (_, final args) =>
  //     PatientInformation(user: args! as UserEntity),
  // CreateNewPasswordView.routeName: (_, final args) {
  //   final data = args! as CreateNewPasswordViewArgs;
  //   return CreateNewPasswordView(email: data.email, code: data.code);
  // },
};

Route<dynamic>? Function(RouteSettings)? onGenerateRoute = (final settings) {
  final builder =
      _routes[settings.name] ??
      (_, _) => const Scaffold(body: Center(child: Text('Page not found')));
  return MaterialPageRoute(
    builder: (final context) => builder(context, settings.arguments),
    settings: settings,
  );
};
