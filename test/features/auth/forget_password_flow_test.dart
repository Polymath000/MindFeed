import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/features/auth/domain/entities/auth_result_entity.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/auth/domain/usecases/forget_password_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/update_password_use_case.dart';
import 'package:mind_feed/features/auth/presentation/controllers/change_password_cubit/change_password_cubit.dart';
import 'package:mind_feed/features/auth/presentation/controllers/forget_password_cubit/forget_password_cubit.dart';
import 'package:mind_feed/features/auth/presentation/views/change_password_view.dart';
import 'package:mind_feed/features/auth/presentation/views/send_code_view.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_text_field.dart';

class _FakeAuthRepository implements AuthRepository {
  ApiResult<void> forgetPasswordResult = const Success(null);
  ApiResult<void> updatePasswordResult = const Success(null);
  String? lastForgetPasswordEmail;
  String? lastUpdatedPassword;

  @override
  Future<ApiResult<void>> forgetPassword(String email) async {
    lastForgetPasswordEmail = email;
    return forgetPasswordResult;
  }

  @override
  Future<ApiResult<void>> updatePassword({required String newPassword}) async {
    lastUpdatedPassword = newPassword;
    return updatePasswordResult;
  }

  @override
  Future<ApiResult<String>> login(LoginParams params) async =>
      const Success('token');

  @override
  Future<ApiResult<AuthResultEntity>> signup(SignupParams params) async =>
      const Success(AuthResultEntity(hasActiveSession: false, email: 'test@mail.com'));

  @override
  Future<ApiResult<String>> verifyOtp({
    required String email,
    required String token,
    bool isPasswordReset = false,
  }) async =>
      const Success('token');

  @override
  Future<ApiResult<void>> resendOtp({
    required String email,
    bool isPasswordReset = false,
  }) async =>
      const Success(null);

  @override
  Future<ApiResult<String>> verifyRecoveryOtp({
    required String email,
    required String token,
  }) async =>
      const Success('token');

  @override
  Future<ApiResult<void>> logout() async => const Success(null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeAuthRepository fakeRepo;
  late ForgetPasswordUseCase forgetPasswordUseCase;
  late UpdatePasswordUseCase updatePasswordUseCase;

  setUp(() {
    fakeRepo = _FakeAuthRepository();
    forgetPasswordUseCase = ForgetPasswordUseCase(repo: fakeRepo);
    updatePasswordUseCase = UpdatePasswordUseCase(repo: fakeRepo);
  });

  group('ForgetPasswordUseCase', () {
    test('returns Success when repository succeeds', () async {
      fakeRepo.forgetPasswordResult = const Success(null);
      final result = await forgetPasswordUseCase.call(email: 'user@example.com');

      expect(result, isA<Success<void>>());
      expect(fakeRepo.lastForgetPasswordEmail, 'user@example.com');
    });

    test('returns FailureResult when repository fails', () async {
      fakeRepo.forgetPasswordResult =
          const FailureResult(ServerFailure('User not found'));
      final result = await forgetPasswordUseCase.call(email: 'user@example.com');

      expect(result, isA<FailureResult<void>>());
      result.when(
        success: (_) => fail('Expected failure'),
        failure: (f) => expect(f.message, 'User not found'),
      );
    });
  });

  group('UpdatePasswordUseCase', () {
    test('returns Success when repository succeeds', () async {
      fakeRepo.updatePasswordResult = const Success(null);
      final result = await updatePasswordUseCase.call(newPassword: 'NewPassword123!');

      expect(result, isA<Success<void>>());
      expect(fakeRepo.lastUpdatedPassword, 'NewPassword123!');
    });

    test('returns FailureResult when repository fails', () async {
      fakeRepo.updatePasswordResult =
          const FailureResult(ServerFailure('Weak password'));
      final result = await updatePasswordUseCase.call(newPassword: 'weak');

      expect(result, isA<FailureResult<void>>());
      result.when(
        success: (_) => fail('Expected failure'),
        failure: (f) => expect(f.message, 'Weak password'),
      );
    });
  });

  group('ForgetPasswordCubit', () {
    test('emits Loading then Success on valid email submission', () async {
      final cubit = ForgetPasswordCubit(forgetPasswordUseCase: forgetPasswordUseCase);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ForgetPasswordLoading>(),
          isA<ForgetPasswordSuccess>().having(
            (s) => s.email,
            'email',
            'user@example.com',
          ),
        ]),
      );

      await cubit.sendResetInstructions(email: 'user@example.com');
      await cubit.close();
    });

    test('emits Loading then Failure on error', () async {
      fakeRepo.forgetPasswordResult =
          const FailureResult(ServerFailure('Network unreachable'));
      final cubit = ForgetPasswordCubit(forgetPasswordUseCase: forgetPasswordUseCase);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ForgetPasswordLoading>(),
          isA<ForgetPasswordFailure>().having(
            (s) => s.errorMessage,
            'errorMessage',
            'Network unreachable',
          ),
        ]),
      );

      await cubit.sendResetInstructions(email: 'user@example.com');
      await cubit.close();
    });
  });

  group('ChangePasswordCubit', () {
    test('emits Loading then Success on password update', () async {
      final cubit = ChangePasswordCubit(updatePasswordUseCase: updatePasswordUseCase);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ChangePasswordLoading>(),
          isA<ChangePasswordSuccess>(),
        ]),
      );

      await cubit.updatePassword(newPassword: 'NewPassword123!');
      await cubit.close();
    });

    test('emits Loading then Failure on update error', () async {
      fakeRepo.updatePasswordResult =
          const FailureResult(ServerFailure('Update failed'));
      final cubit = ChangePasswordCubit(updatePasswordUseCase: updatePasswordUseCase);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ChangePasswordLoading>(),
          isA<ChangePasswordFailure>().having(
            (s) => s.errorMessage,
            'errorMessage',
            'Update failed',
          ),
        ]),
      );

      await cubit.updatePassword(newPassword: 'NewPassword123!');
      await cubit.close();
    });
  });

  group('SendCodeView widget tests', () {
    testWidgets('renders reset password view and validates empty input', (tester) async {
      final cubit = ForgetPasswordCubit(forgetPasswordUseCase: forgetPasswordUseCase);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) =>
              MaterialPageRoute(builder: (_) => const Scaffold(body: Text('routed'))),
          home: SendCodeView(cubit: cubit),
        ),
      );

      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('Send Instructions'), findsOneWidget);

      await tester.tap(find.text('Send Instructions'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('triggers cubit when valid email is submitted', (tester) async {
      final cubit = ForgetPasswordCubit(forgetPasswordUseCase: forgetPasswordUseCase);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) =>
              MaterialPageRoute(builder: (_) => const Scaffold(body: Text('routed'))),
          home: SendCodeView(cubit: cubit),
        ),
      );

      await tester.enterText(
        find.descendant(of: find.byType(EmailTextField), matching: find.byType(EditableText)),
        'test@mindfeed.app',
      );
      await tester.pump();

      await tester.tap(find.text('Send Instructions'));
      await tester.pump();

      expect(fakeRepo.lastForgetPasswordEmail, 'test@mindfeed.app');
    });
  });

  group('ChangePasswordView widget tests', () {
    testWidgets('renders password fields and detects mismatch', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final cubit = ChangePasswordCubit(updatePasswordUseCase: updatePasswordUseCase);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) =>
              MaterialPageRoute(builder: (_) => const Scaffold(body: Text('routed'))),
          home: ChangePasswordView(
            email: 'test@mindfeed.app',
            cubit: cubit,
          ),
        ),
      );

      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Update Password'), findsOneWidget);

      final passwordFields = find.byType(PasswordTextField);
      expect(passwordFields, findsNWidgets(2));

      await tester.enterText(
        find.descendant(of: passwordFields.at(0), matching: find.byType(EditableText)),
        'Password123!',
      );
      await tester.enterText(
        find.descendant(of: passwordFields.at(1), matching: find.byType(EditableText)),
        'Different123!',
      );
      await tester.pump();

      await tester.ensureVisible(find.text('Update Password'));
      await tester.tap(find.text('Update Password'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
      expect(fakeRepo.lastUpdatedPassword, isNull);
    });

    testWidgets('submits update password when passwords match and are valid', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final cubit = ChangePasswordCubit(updatePasswordUseCase: updatePasswordUseCase);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) =>
              MaterialPageRoute(builder: (_) => const Scaffold(body: Text('routed'))),
          home: ChangePasswordView(
            email: 'test@mindfeed.app',
            cubit: cubit,
          ),
        ),
      );

      final passwordFields = find.byType(PasswordTextField);
      await tester.enterText(
        find.descendant(of: passwordFields.at(0), matching: find.byType(EditableText)),
        'Password123!',
      );
      await tester.enterText(
        find.descendant(of: passwordFields.at(1), matching: find.byType(EditableText)),
        'Password123!',
      );
      await tester.pump();

      await tester.ensureVisible(find.text('Update Password'));
      await tester.tap(find.text('Update Password'));
      await tester.pump();

      expect(fakeRepo.lastUpdatedPassword, 'Password123!');
    });
  });
}
