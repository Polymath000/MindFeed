import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import '../entities/startup_destination.dart';

class CheckAppStartupUseCase {
  const CheckAppStartupUseCase();

  Future<StartupDestination> call() async {
    final bool isOnboardingSeen =
        SharedPreferencesSingleton.getBool(isOnboardingSeenKey) ?? false;
    if (!isOnboardingSeen) {
      return const StartupOnboarding();
    }

    return const StartupMain();
  }
}
