import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/auth/domain/repos/auth_repo.dart';
import 'package:mind_feed/features/auth/domain/usecases/login_use_case.dart';
import 'package:mind_feed/features/auth/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:mind_feed/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mind_feed/features/profile/data/repos/profile_repo_impl.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/profile/domain/usecases/check_user_has_categories_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthRepo extends Fake implements AuthRepository {
  final bool shouldSucceed;
  final String fakeToken;

  FakeAuthRepo({this.shouldSucceed = true, this.fakeToken = 'mock-token'});

  @override
  Future<ApiResult<String>> login(LoginParams params) async {
    if (shouldSucceed) {
      return Success(fakeToken);
    }
    return FailureResult(ServerFailure('Invalid credentials'));
  }
}

class FakeProfileRepo extends Fake implements ProfileRepository {
  List<Map<String, dynamic>> mockFavorites;
  FakeProfileRepo({this.mockFavorites = const []});

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(String userId) async {
    return Success(mockFavorites);
  }
}

class MockRemoteDataSourceWithProfiles extends Fake implements ProfileRemoteDataSource {
  final Map<String, dynamic>? profileData;

  MockRemoteDataSourceWithProfiles({this.profileData});

  @override
  Future<List<Map<String, dynamic>>> getFavoriteCategories(String userId) async {
    if (profileData != null && profileData!['favorite_categories'] != null) {
      final raw = profileData!['favorite_categories'];
      if (raw is List && raw.isNotEmpty) {
        return raw.map((item) => {'name': item.toString()}).toList();
      }
    }
    return [];
  }

  @override
  Future<void> saveFavoriteCategoriesToProfile({
    required String userId,
    required List<String> categories,
  }) async {}

  @override
  Future<void> setFavoriteCategories({
    required String userId,
    required List<String> categoryIds,
  }) async {}

  @override
  Future<List<Map<String, dynamic>>> getCategories() async => [];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferencesSingleton.init();
  });

  group('CheckUserHasCategoriesUseCase', () {
    test('returns Success(true) when favorite categories exist in profile', () async {
      final repo = FakeProfileRepo(mockFavorites: [
        {'name': 'Technology'},
        {'name': 'Science'},
      ]);
      final useCase = CheckUserHasCategoriesUseCase(repo);

      final result = await useCase(userId: 'test-uuid');

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isTrue);
    });

    test('returns Success(false) when favorite categories are empty in profile', () async {
      final repo = FakeProfileRepo(mockFavorites: []);
      final useCase = CheckUserHasCategoriesUseCase(repo);

      final result = await useCase(userId: 'test-uuid');

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isFalse);
    });

    test('queries profile repository even when userId is null or empty', () async {
      final repo = FakeProfileRepo(mockFavorites: [
        {'name': 'General'},
      ]);
      final useCase = CheckUserHasCategoriesUseCase(repo);

      final result = await useCase(userId: null);

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isTrue);
    });
  });

  group('LoginCubit with Categories in Profile', () {
    test('emits LoginSuccess directly when user already chose categories', () async {
      final authRepo = FakeAuthRepo(shouldSucceed: true);
      final profileRepo = FakeProfileRepo(mockFavorites: [
        {'name': 'Technology'},
        {'name': 'Science'},
      ]);
      final loginUseCase = LoginUseCase(repo: authRepo);
      final checkCategoriesUseCase = CheckUserHasCategoriesUseCase(profileRepo);

      final cubit = LoginCubit(
        loginUseCase: loginUseCase,
        checkUserHasCategoriesUseCase: checkCategoriesUseCase,
      );

      final states = <LoginState>[];
      cubit.stream.listen(states.add);

      await cubit.eitherFailureOrLogin(
        email: 'user@example.com',
        password: 'password123',
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<LoginSuccess>());
      expect(states, contains(isA<LoginSuccess>()));

      cubit.close();
    });

    test('emits LoginRequiresCategories when user has not chosen categories yet', () async {
      final authRepo = FakeAuthRepo(shouldSucceed: true);
      final profileRepo = FakeProfileRepo(mockFavorites: []);
      final loginUseCase = LoginUseCase(repo: authRepo);
      final checkCategoriesUseCase = CheckUserHasCategoriesUseCase(profileRepo);

      final cubit = LoginCubit(
        loginUseCase: loginUseCase,
        checkUserHasCategoriesUseCase: checkCategoriesUseCase,
      );

      final states = <LoginState>[];
      cubit.stream.listen(states.add);

      await cubit.eitherFailureOrLogin(
        email: 'newuser@example.com',
        password: 'password123',
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<LoginRequiresCategories>());
      final requiresState = cubit.state as LoginRequiresCategories;
      expect(requiresState.userEntity.email, equals('newuser@example.com'));

      cubit.close();
    });
  });

  group('ProfileRepoImpl reads profiles.favorite_categories', () {
    test('marks AppConstants.hasCompletedCategoriesKey as true when categories found', () async {
      final dataSource = MockRemoteDataSourceWithProfiles(
        profileData: {
          'id': 'user-123',
          'favorite_categories': ['Technology', 'Science'],
        },
      );
      final repo = ProfileRepoImpl(remoteDataSource: dataSource);

      final result = await repo.getFavoriteCategories('user-123');

      expect(result, isA<Success<List<Map<String, dynamic>>>>());
      expect((result as Success).data.length, equals(2));
      expect(
        SharedPreferencesSingleton.getBool(AppConstants.hasCompletedCategoriesKey),
        isTrue,
      );
    });
  });
}
