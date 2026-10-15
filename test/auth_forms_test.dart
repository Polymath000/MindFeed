import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/features/auth/domain/entities/auth_result_entity.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/auth/domain/usecases/login_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/signup_use_case.dart';
import 'package:mind_feed/features/auth/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:mind_feed/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/login_form.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/sign_up_form_body.dart';

class _FakeAuthRepo implements AuthRepository {
  @override
  Future<ApiResult<String>> login(LoginParams params) async =>
      const Success('token');

  @override
  Future<ApiResult<AuthResultEntity>> signup(SignupParams params) async =>
      const Success(AuthResultEntity(hasActiveSession: false, email: 'test@example.com'));

  @override
  Future<ApiResult<String>> verifyOtp({required String email, required String token}) async =>
      const Success('token');

  @override
  Future<ApiResult<void>> resendOtp({required String email}) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> forgetPassword(String email) async =>
      const Success(null);

  @override
  Future<ApiResult<void>> updatePassword({required String newPassword}) async =>
      const Success(null);

  @override
  Future<ApiResult<String>> verifyRecoveryOtp({
    required String email,
    required String token,
  }) async =>
      const Success('test-recovery-token');

  @override
  Future<ApiResult<void>> logout() async =>
      const Success(null);
}

void main() {
  group('LoginForm', () {
    testWidgets('renders inputs and triggers validation on invalid submit',
        (tester) async {
      final fakeRepo = _FakeAuthRepo();
      final loginCubit = LoginCubit(loginUseCase: LoginUseCase(repo: fakeRepo));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: loginCubit,
              child: const SingleChildScrollView(child: LoginForm()),
            ),
          ),
        ),
      );

      expect(find.byType(LoginForm), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });
  });

  group('SignUpFormBody', () {
    testWidgets('dynamically updates password requirements via ValueNotifier',
        (tester) async {
      final fakeRepo = _FakeAuthRepo();
      final signupCubit =
          SignupCubit(signUpUseCase: SignupUseCase(repo: fakeRepo));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: signupCubit,
              child: const SingleChildScrollView(child: SignUpFormBody()),
            ),
          ),
        ),
      );

      expect(find.byType(SignUpFormBody), findsOneWidget);
      expect(find.text('Password requirements:'), findsOneWidget);
      expect(find.byIcon(AppIcons.radioButtonUnchecked), findsNWidgets(4));

      await tester.enterText(
        find.descendant(
          of: find.byWidgetPredicate(
            (w) => w is PasswordTextField && w.hintText == 'Create password',
          ),
          matching: find.byType(EditableText),
        ),
        'Password123!',
      );
      await tester.pump();

      expect(find.byIcon(AppIcons.checkCircleRounded), findsNWidgets(4));
    });
  });
}