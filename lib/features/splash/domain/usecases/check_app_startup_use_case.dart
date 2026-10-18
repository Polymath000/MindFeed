import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import '../entities/startup_destination.dart';

class CheckAppStartupUseCase {
  final AuthRepository _authRepository;

  const CheckAppStartupUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<StartupDestination> call() async {
    final bool isOnboardingSeen =
        SharedPreferencesSingleton.getBool(isOnboardingSeenKey) ?? false;
    if (!isOnboardingSeen) return const StartupOnboarding();

    final token = SharedPreferencesSingleton.getString(AppConstants.tokenKey);
    final bool hasToken = token != null && token.isNotEmpty;
    final bool hasSession = _hasActiveSession();

    if (!hasToken && !hasSession) return const StartupLogin();

    if (!_hasCompletedCategories()) {
      await _cleanupIncompleteSession();
      return const StartupLogin();
    }

    return const StartupMain();
  }

  bool _hasActiveSession() {
    try {
      return _authRepository.hasActiveSession();
    } catch (_) {
      return false;
    }
  }

  bool _hasCompletedCategories() {
    return SharedPreferencesSingleton.getBool(
          AppConstants.hasCompletedCategoriesKey,
        ) ??
        false;
  }

  Future<void> _cleanupIncompleteSession() async {
    try {
      await _authRepository.logout();
    } catch (_) {}
    try {
      await SharedPreferencesSingleton.remove(AppConstants.tokenKey);
      await SharedPreferencesSingleton.remove(
        AppConstants.hasCompletedCategoriesKey,
      );
    } catch (_) {}
  }
}
