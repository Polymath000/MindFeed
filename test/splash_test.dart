import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/splash/domain/entities/startup_destination.dart';
import 'package:mind_feed/features/splash/domain/usecases/check_app_startup_use_case.dart';
import 'package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_cubit.dart';
import 'package:mind_feed/features/splash/presentation/controllers/splash_cubit/splash_state.dart';
import 'package:mind_feed/features/splash/presentation/widgets/splash_view_body.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthRepository extends Fake implements AuthRepository {
  bool activeSession = false;
  bool logoutCalled = false;

  @override
  bool hasActiveSession() => activeSession;

  @override
  Future<ApiResult<void>> logout() async {
    logoutCalled = true;
    return const Success(null);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthRepository fakeAuthRepo;

  setUp(() {
    fakeAuthRepo = FakeAuthRepository();
  });

  group('CheckAppStartupUseCase', () {
    test('returns StartupOnboarding when onboarding not seen', () async {
      SharedPreferences.setMockInitialValues({});
      await SharedPreferencesSingleton.init();

      final useCase = CheckAppStartupUseCase(authRepository: fakeAuthRepo);
      final destination = await useCase();

      expect(destination, isA<StartupOnboarding>());
    });

    test('returns StartupLogin when onboarding seen but user not logged in', () async {
      SharedPreferences.setMockInitialValues({
        isOnboardingSeenKey: true,
      });
      await SharedPreferencesSingleton.init();

      final useCase = CheckAppStartupUseCase(authRepository: fakeAuthRepo);
      final destination = await useCase();

      expect(destination, isA<StartupLogin>());
    });

    test('returns StartupMain when onboarding seen and user has token', () async {
      SharedPreferences.setMockInitialValues({
        isOnboardingSeenKey: true,
        AppConstants.tokenKey: 'valid_access_token',
        AppConstants.hasCompletedCategoriesKey: true,
      });
      await SharedPreferencesSingleton.init();

      final useCase = CheckAppStartupUseCase(authRepository: fakeAuthRepo);
      final destination = await useCase();

      expect(destination, isA<StartupMain>());
    });

    test('returns StartupMain when onboarding seen and user has active session', () async {
      SharedPreferences.setMockInitialValues({
        isOnboardingSeenKey: true,
        AppConstants.hasCompletedCategoriesKey: true,
      });
      await SharedPreferencesSingleton.init();
      fakeAuthRepo.activeSession = true;

      final useCase = CheckAppStartupUseCase(authRepository: fakeAuthRepo);
      final destination = await useCase();

      expect(destination, isA<StartupMain>());
    });

    test('calls logout on incomplete session when categories are missing', () async {
      SharedPreferences.setMockInitialValues({
        isOnboardingSeenKey: true,
        AppConstants.tokenKey: 'valid_access_token',
        AppConstants.hasCompletedCategoriesKey: false,
      });
      await SharedPreferencesSingleton.init();

      final useCase = CheckAppStartupUseCase(authRepository: fakeAuthRepo);
      final destination = await useCase();

      expect(destination, isA<StartupLogin>());
      expect(fakeAuthRepo.logoutCalled, isTrue);
    });
  });

  group('SplashCubit', () {
    test('emits SplashNavigateToOnboarding when onboarding is needed', () async {
      SharedPreferences.setMockInitialValues({});
      await SharedPreferencesSingleton.init();

      final cubit = SplashCubit(
        checkAppStartupUseCase: CheckAppStartupUseCase(authRepository: fakeAuthRepo),
        minDisplayDuration: Duration.zero,
      );

      expectLater(
        cubit.stream,
        emits(isA<SplashNavigateToOnboarding>()),
      );

      await cubit.initApp();
      await cubit.close();
    });

    test('emits SplashNavigateToLogin when onboarding seen but not logged in', () async {
      SharedPreferences.setMockInitialValues({
        isOnboardingSeenKey: true,
      });
      await SharedPreferencesSingleton.init();

      final cubit = SplashCubit(
        checkAppStartupUseCase: CheckAppStartupUseCase(authRepository: fakeAuthRepo),
        minDisplayDuration: Duration.zero,
      );

      expectLater(
        cubit.stream,
        emits(isA<SplashNavigateToLogin>()),
      );

      await cubit.initApp();
      await cubit.close();
    });

    test('emits SplashNavigateToMain when onboarding seen and user has token', () async {
      SharedPreferences.setMockInitialValues({
        isOnboardingSeenKey: true,
        AppConstants.tokenKey: 'valid_access_token',
        AppConstants.hasCompletedCategoriesKey: true,
      });
      await SharedPreferencesSingleton.init();

      final cubit = SplashCubit(
        checkAppStartupUseCase: CheckAppStartupUseCase(authRepository: fakeAuthRepo),
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
