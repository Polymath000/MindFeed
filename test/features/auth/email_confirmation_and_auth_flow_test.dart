import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/networking/network_info.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/auth/data/datasources/auth_api_source.dart';
import 'package:mind_feed/features/auth/data/datasources/user_cache_source.dart';
import 'package:mind_feed/features/auth/data/repos/auth_repo_impl.dart';
import 'package:mind_feed/features/auth/domain/entities/auth_result_entity.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/auth/domain/usecases/login_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/resend_otp_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/signup_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:mind_feed/features/auth/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:mind_feed/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class FakeNetworkInfo extends Fake implements NetworkInfo {
  final bool connected;
  FakeNetworkInfo({this.connected = true});

  @override
  Future<bool> get isConnected async => connected;
}

class FakeUserCacheDataSource extends Fake implements UserCacheDataSource {}

class FakeAuthApiSource extends Fake implements AuthApiSource {
  AuthResultEntity? signUpResult;
  Exception? signUpException;
  String? verifyOtpResult;
  Exception? verifyOtpException;
  bool resendOtpCalled = false;
  String? lastResentEmail;

  @override
  Future<AuthResultEntity> signUp({required SignupParams params}) async {
    if (signUpException != null) throw signUpException!;
    return signUpResult!;
  }

  @override
  Future<String> verifyOtp({
    required String email,
    required String token,
    bool isPasswordReset = false,
  }) async {
    if (verifyOtpException != null) throw verifyOtpException!;
    return verifyOtpResult!;
  }

  @override
  Future<void> resendOtp({
    required String email,
    bool isPasswordReset = false,
  }) async {
    resendOtpCalled = true;
    lastResentEmail = email;
  }
}

class FakeAuthRepository extends Fake implements AuthRepository {
  ApiResult<AuthResultEntity>? signupResult;
  ApiResult<String>? loginResult;

  @override
  Future<ApiResult<AuthResultEntity>> signup(SignupParams params) async {
    return signupResult!;
  }

  @override
  Future<ApiResult<String>> login(LoginParams params) async {
    return loginResult!;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthApiSource fakeApiSource;
  late FakeNetworkInfo fakeNetworkInfo;
  late FakeUserCacheDataSource fakeUserCache;
  late AuthRepoImpl authRepo;

  setUpAll(() async {
    HttpOverrides.global = _TestHttpOverrides();
    SharedPreferences.setMockInitialValues({});
    await SharedPreferencesSingleton.init();
  });

  setUp(() {
    fakeApiSource = FakeAuthApiSource();
    fakeNetworkInfo = FakeNetworkInfo(connected: true);
    fakeUserCache = FakeUserCacheDataSource();
    authRepo = AuthRepoImpl(
      authApiSource: fakeApiSource,
      networkInfo: fakeNetworkInfo,
      userCacheDataSource: fakeUserCache,
    );
  });

  tearDown(() async {
    await SharedPreferencesSingleton.remove(AppConstants.tokenKey);
  });

  group('Acceptance Criteria 1 & 2: Pending Confirmation & No Fake Tokens', () {
    test('signup with pending confirmation does not store user ID and returns hasActiveSession=false', () async {
      const params = SignupParams(
        displayName: 'Test User',
        email: 'test@example.com',
        password: 'Password123!',
      );

      fakeApiSource.signUpResult = const AuthResultEntity(
        hasActiveSession: false,
        email: 'test@example.com',
        accessToken: null,
        userId: 'user-uuid-1234',
      );

      final result = await authRepo.signup(params);

      expect(result, isA<Success<AuthResultEntity>>());
      result.when(
        success: (authResult) {
          expect(authResult.hasActiveSession, isFalse);
          expect(authResult.accessToken, isNull);
          expect(authResult.userId, equals('user-uuid-1234'));
        },
        failure: (_) => fail('Expected success'),
      );

      final savedToken = SharedPreferencesSingleton.getString(AppConstants.tokenKey);
      expect(savedToken, isNull);
    });

    test('signup with active session returns entity without storing token prior to category onboarding', () async {
      const params = SignupParams(
        displayName: 'OAuth User',
        email: 'oauth@example.com',
        password: 'Password123!',
      );

      fakeApiSource.signUpResult = const AuthResultEntity(
        hasActiveSession: true,
        email: 'oauth@example.com',
        accessToken: 'real_jwt_access_token_999',
        userId: 'user-uuid-5678',
      );

      final result = await authRepo.signup(params);

      expect(result, isA<Success<AuthResultEntity>>());
      final savedToken = SharedPreferencesSingleton.getString(AppConstants.tokenKey);
      expect(savedToken, isNull);
    });

    test('SignupCubit emits SignupRequiresConfirmation when hasActiveSession is false', () async {
      final fakeRepo = FakeAuthRepository();
      fakeRepo.signupResult = const Success(
        AuthResultEntity(
          hasActiveSession: false,
          email: 'reader@example.com',
        ),
      );

      final useCase = SignupUseCase(repo: fakeRepo);
      final cubit = SignupCubit(signUpUseCase: useCase);

      const params = SignupParams(
        displayName: 'Reader',
        email: 'reader@example.com',
        password: 'Password123!',
      );

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<SignupLoading>(),
          isA<SignupRequiresConfirmation>().having(
            (s) => s.email,
            'email',
            'reader@example.com',
          ),
        ]),
      );

      await cubit.eitherFailureOrSignup(params: params);
      await cubit.close();
    });
  });

  group('Acceptance Criteria 3 & 4: OTP Verification & Error Handling', () {
    test('valid OTP creates genuine session without storing token prior to category onboarding', () async {
      fakeApiSource.verifyOtpResult = 'genuine_session_token_abc';

      final verifyUseCase = VerifyOtpUseCase(repo: authRepo);
      final result = await verifyUseCase.call(email: 'test@example.com', token: '123456');

      expect(result, isA<Success<String>>());
      result.when(
        success: (token) {
          expect(token, equals('genuine_session_token_abc'));
        },
        failure: (_) => fail('Expected success'),
      );

      final savedToken = SharedPreferencesSingleton.getString(AppConstants.tokenKey);
      expect(savedToken, isNull);
    });

    test('invalid or expired OTP returns failure without storing token', () async {
      fakeApiSource.verifyOtpException = Exception('Token has expired or is invalid');

      final verifyUseCase = VerifyOtpUseCase(repo: authRepo);
      final result = await verifyUseCase.call(email: 'test@example.com', token: '000000');

      expect(result, isA<FailureResult<String>>());
      final savedToken = SharedPreferencesSingleton.getString(AppConstants.tokenKey);
      expect(savedToken, isNull);
    });
  });

  group('Acceptance Criterion 5: Resend Confirmation', () {
    test('resendOtp invokes data source with email', () async {
      final resendUseCase = ResendOtpUseCase(repo: authRepo);
      final result = await resendUseCase.call(email: 'test@example.com');

      expect(result, isA<Success<void>>());
      expect(fakeApiSource.resendOtpCalled, isTrue);
      expect(fakeApiSource.lastResentEmail, equals('test@example.com'));
    });
  });

  group('Acceptance Criterion 8: Login before verification presents recovery path', () {
    test('LoginCubit provides email in LoginFailure when email is not confirmed', () async {
      final fakeRepo = FakeAuthRepository();
      fakeRepo.loginResult = const FailureResult(ServerFailure('Email not confirmed'));

      final loginUseCase = LoginUseCase(repo: fakeRepo);
      final cubit = LoginCubit(loginUseCase: loginUseCase);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<LoginLoading>(),
          isA<LoginFailure>()
              .having((s) => s.errorMessage, 'errorMessage', contains('Email not confirmed'))
              .having((s) => s.email, 'email', 'unconfirmed@example.com'),
        ]),
      );

      await cubit.eitherFailureOrLogin(
        email: 'unconfirmed@example.com',
        password: 'Password123!',
      );

      await cubit.close();
    });
  });

  group('Acceptance Criterion 7: Edge Function Callback Verification', () {
    const baseUrl = AppConstants.authConfirmRedirectUrl;

    Future<http.StreamedResponse> getWithoutRedirect(String url) async {
      final request = http.Request('GET', Uri.parse(url))..followRedirects = false;
      final client = http.Client();
      return await client.send(request);
    }

    test('bare endpoint URL redirects to login-callback', () async {
      final response = await getWithoutRedirect(baseUrl);
      expect(response.statusCode, equals(302));
      expect(response.headers['location'], equals('mindfeed://login-callback'));
    });

    test('valid-shaped callback redirects and preserves callback code', () async {
      final response = await getWithoutRedirect('$baseUrl?code=test-code-1234');
      expect(response.statusCode, equals(302));
      expect(response.headers['location'], equals('mindfeed://login-callback?code=test-code-1234'));
    });

    test('error-only callback redirects and preserves error state', () async {
      final response = await getWithoutRedirect('$baseUrl?error=access_denied&error_description=Link+expired');
      expect(response.statusCode, equals(302));
      expect(response.headers['location'], contains('mindfeed://login-callback'));
      expect(response.headers['location'], contains('error=access_denied'));
      expect(response.headers['location'], contains('Link+expired'));
    });

    test('callback containing error_code redirects and preserves error description', () async {
      final response = await getWithoutRedirect('$baseUrl?error_code=otp_expired&error_description=Code+expired');
      expect(response.statusCode, equals(302));
      expect(response.headers['location'], contains('mindfeed://login-callback'));
      expect(response.headers['location'], contains('error_code=otp_expired'));
    });
  });
}
