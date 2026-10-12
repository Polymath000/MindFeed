import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/splash/domain/entities/startup_destination.dart';
import 'package:mind_feed/features/splash/domain/usecases/check_app_startup_use_case.dart';
import 'package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_cubit.dart';
import 'package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_state.dart';
import 'package:mind_feed/features/splash/presentation/widgets/splash_view_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CheckAppStartupUseCase', () {
    test('returns StartupOnboarding when onboarding not seen', () async {
      SharedPreferences.setMockInitialValues({});
      await SharedPreferencesSingleton.init();

      const useCase = CheckAppStartupUseCase();
      final destination = await useCase();

      expect(destination, isA<StartupOnboarding>());
    });

    test('returns StartupMain when onboarding seen', () async {
      SharedPreferences.setMockInitialValues({
        isOnboardingSeenKey: true,
      });
      await SharedPreferencesSingleton.init();

      const useCase = CheckAppStartupUseCase();
      final destination = await useCase();

      expect(destination, isA<StartupMain>());
    });
  });

  group('SplashCubit', () {
    test('emits SplashNavigateToOnboarding when onboarding is needed', () async {
      SharedPreferences.setMockInitialValues({});
      await SharedPreferencesSingleton.init();

      final cubit = SplashCubit(
        checkAppStartupUseCase: const CheckAppStartupUseCase(),
        minDisplayDuration: Duration.zero,
      );

      expectLater(
        cubit.stream,
        emits(isA<SplashNavigateToOnboarding>()),
      );

      await cubit.initApp();
      await cubit.close();
    });

    test('emits SplashNavigateToMain when onboarding has been seen', () async {
      SharedPreferences.setMockInitialValues({
        isOnboardingSeenKey: true,
      });
      await SharedPreferencesSingleton.init();

      final cubit = SplashCubit(
        checkAppStartupUseCase: const CheckAppStartupUseCase(),
        minDisplayDuration: Duration.zero,
      );

      expectLater(
        cubit.stream,
        emits(isA<SplashNavigateToMain>()),
      );

      await cubit.initApp();
      await cubit.close();
    });
  });

  group('Splash UI Rendering', () {
    testWidgets('renders MindFeed title and curated edition tagline', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SplashViewBody(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('MindFeed'), findsOneWidget);
      expect(find.text('THE CURATED EDITION'), findsOneWidget);
    });
  });
}
