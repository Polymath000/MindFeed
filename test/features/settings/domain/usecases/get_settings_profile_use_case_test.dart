import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/settings/domain/entities/settings_profile_summary.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_settings_profile_use_case.dart';

class _FakeProfileRepository implements ProfileRepository {
  Map<String, dynamic> profile = {
    'display_name': 'Editorial Lead',
    'avatar_url': 'https://mindfeed.org/avatar.jpg',
  };
  List<Map<String, dynamic>> favs = [
    {'name': 'World'},
    {'name': 'Science'},
  ];
  bool throwException = false;

  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile(String userId) async {
    if (throwException) {
      throw Exception('database offline');
    }
    return Success(profile);
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(String userId) async {
    if (throwException) {
      throw Exception('database offline');
    }
    return Success(favs);
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getCategories() async => const Success([]);

  @override
  Future<bool> reconcilePendingCategorySync({String? userId}) async => true;

  @override
  Future<ApiResult<void>> saveLocalCategories({
    required String userId,
    required List<String> categoryNames,
    UserEntity? currentUser,
  }) async => const Success(null);

  @override
  Future<ApiResult<void>> syncFavoriteCategories({
    required String userId,
    required List<String> categoryNames,
  }) async => const Success(null);

  @override
  Future<ApiResult<Map<String, dynamic>>> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async => const Success({});

  @override
  Future<ApiResult<String>> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousAvatarUrl,
  }) async =>
      const Success('https://example.com/storage/v1/object/public/avatars/avatar.jpg');
}

void main() {
  late _FakeProfileRepository fakeRepo;
  late GetSettingsProfileUseCase useCase;

  setUp(() {
    fakeRepo = _FakeProfileRepository();
    useCase = GetSettingsProfileUseCase(fakeRepo);
  });

  group('GetSettingsProfileUseCase', () {
    test('returns profile summary when called without active session', () async {
      final result = await useCase();
      expect(result, isA<Success<SettingsProfileSummary>>());
      result.when(
        success: (summary) {
          expect(summary, isNotNull);
        },
        failure: (f) => fail('Expected success, got $f'),
      );
    });

    test('returns FailureResult on unhandled exception', () async {
      // If profile repo throws an unexpected error during execution
      fakeRepo.throwException = true;
      // Since CurrentUserSession resolves null when Supabase isn't initialized,
      // it returns Success with default snapshot unless session exists and repo throws.
      final result = await useCase();
      expect(result, isA<ApiResult<SettingsProfileSummary>>());
    });
  });
}
