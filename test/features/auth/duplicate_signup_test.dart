import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/features/auth/domain/entities/auth_result_entity.dart';
import 'package:mind_feed/features/auth/domain/usecases/signup_use_case.dart';
import 'package:mind_feed/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/sign_up_view_body.dart';

class MockSignupUseCase extends Fake implements SignupUseCase {
  ApiResult<AuthResultEntity> Function(SignupParams params)? onCall;

  @override
  Future<ApiResult<AuthResultEntity>> call({required SignupParams params}) async {
    if (onCall != null) {
      return onCall!(params);
    }
    return const FailureResult(ServerFailure('An unexpected error occurred.'));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSignupUseCase mockUseCase;
  late SignupCubit cubit;

  setUp(() {
    mockUseCase = MockSignupUseCase();
    cubit = SignupCubit(signUpUseCase: mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('SignupCubit duplicate registration detection', () {
    test('emits isUserAlreadyRegistered true for "The account already exists for that email."', () async {
      mockUseCase.onCall = (params) => const FailureResult(ServerFailure('The account already exists for that email.'));

      await cubit.eitherFailureOrSignup(
        params: const SignupParams(
          displayName: 'Existing',
          email: 'existing@example.com',
          password: 'Password123!',
        ),
      );

      expect(cubit.state, isA<SignupFailure>());
      final failureState = cubit.state as SignupFailure;
      expect(failureState.isUserAlreadyRegistered, isTrue);
      expect(failureState.errorMessage, 'The account already exists for that email.');
    });

    test('emits isUserAlreadyRegistered true for "User already registered"', () async {
      mockUseCase.onCall = (params) => const FailureResult(ServerFailure('User already registered'));

      await cubit.eitherFailureOrSignup(
        params: const SignupParams(
          displayName: 'Existing',
          email: 'existing@example.com',
          password: 'Password123!',
        ),
      );

      expect(cubit.state, isA<SignupFailure>());
      final failureState = cubit.state as SignupFailure;
      expect(failureState.isUserAlreadyRegistered, isTrue);
    });

    test('emits isUserAlreadyRegistered false for general network error', () async {
      mockUseCase.onCall = (params) => const FailureResult(ServerFailure('Network error'));

      await cubit.eitherFailureOrSignup(
        params: const SignupParams(
          displayName: 'User',
          email: 'user@example.com',
          password: 'Password123!',
        ),
      );

      expect(cubit.state, isA<SignupFailure>());
      final failureState = cubit.state as SignupFailure;
      expect(failureState.isUserAlreadyRegistered, isFalse);
    });
  });

  group('SignUpViewBody Duplicate User SnackBar & Navigation', () {
    testWidgets('renders SnackBar with Sign In action and navigates to login when pressed', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      bool navigatedToLogin = false;

      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/signup',
          routes: {
            '/signup': (context) => Builder(
              builder: (ctx) {
                AppTextStyles.init(ctx);
                return BlocProvider<SignupCubit>.value(
                  value: cubit,
                  child: const Scaffold(body: SignUpViewBody()),
                );
              },
            ),
            AppRoutes.login: (context) {
              navigatedToLogin = true;
              return const Scaffold(body: Text('Login Screen'));
            },
          },
        ),
      );

      mockUseCase.onCall = (params) => const FailureResult(ServerFailure('The account already exists for that email.'));

      await cubit.eitherFailureOrSignup(
        params: const SignupParams(
          displayName: 'Existing',
          email: 'existing@example.com',
          password: 'Password123!',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('An account with this email already exists'), findsOneWidget);
      final snackBarAction = find.descendant(
        of: find.byType(SnackBar),
        matching: find.text('Sign In'),
      );
      expect(snackBarAction, findsOneWidget);

      await tester.tap(snackBarAction);
      await tester.pumpAndSettle();

      expect(navigatedToLogin, isTrue);
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });
}
