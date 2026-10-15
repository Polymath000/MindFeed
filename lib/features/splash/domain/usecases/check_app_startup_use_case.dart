import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/auth/data/datasources/auth_api_source.dart';
import '../entities/startup_destination.dart';

class CheckAppStartupUseCase {
  final AuthApiSource? _authApiSource;

  const CheckAppStartupUseCase({AuthApiSource? authApiSource})
      : _authApiSource = authApiSource;

  Future<StartupDestination> call() async {
    final bool isOnboardingSeen =
        SharedPreferencesSingleton.getBool(isOnboardingSeenKey) ?? false;
    if (!isOnboardingSeen) {
      return const StartupOnboarding();
    }

    final token = SharedPreferencesSingleton.getString(AppConstants.tokenKey);
    final bool hasToken = token != null && token.isNotEmpty;

    bool hasSupabaseSession = false;
    try {
      hasSupabaseSession = _authApiSource?.currentUser != null;
    } catch (_) {
      hasSupabaseSession = false;
    }

    if (!hasToken && !hasSupabaseSession) {
      return const StartupLogin();
    }

    return const StartupMain();
  }
}
