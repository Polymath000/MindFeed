import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/articles/data/datasources/author_follow_remote_data_source.dart';
import 'package:mind_feed/core/articles/data/repos/author_follow_repo_impl.dart';
import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/repos/author_follow_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/networking/network_info.dart';

class _FakeNetworkInfo implements NetworkInfo {
  bool isConnectedValue;

  _FakeNetworkInfo({this.isConnectedValue = true});

  @override
  Future<bool> get isConnected async => isConnectedValue;
}

class _FakeAuthorFollowRemoteDataSource implements AuthorFollowRemoteDataSource {
  AuthorFollowSummary summaryToReturn = const AuthorFollowSummary();
  Object? errorToThrow;
  String? lastTargetUserId;
  String? lastAuthorKey;
  String? lastViewerUserId;
  String? lastFollowerId;
  String? lastAuthorId;
  String? lastAuthorName;
  bool followAuthorCalled = false;
  bool unfollowAuthorCalled = false;

  @override
  Future<AuthorFollowSummary> getFollowSummary({
    String? targetUserId,
    String? authorKey,
    String? viewerUserId,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    lastTargetUserId = targetUserId;
    lastAuthorKey = authorKey;
    lastViewerUserId = viewerUserId;
    return summaryToReturn;
  }

  @override
  Future<void> followAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
    String? authorName,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    followAuthorCalled = true;
    lastFollowerId = followerId;
    lastAuthorKey = authorKey;
    lastAuthorId = authorId;
    lastAuthorName = authorName;
  }

  @override
  Future<void> unfollowAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    unfollowAuthorCalled = true;
    lastFollowerId = followerId;
    lastAuthorKey = authorKey;
    lastAuthorId = authorId;
  }
}

class _FakeAuthorFollowRepository implements AuthorFollowRepository {
  AuthorFollowSummary summaryToReturn = const AuthorFollowSummary();
  ApiResult<void>? followResult;
  ApiResult<void>? unfollowResult;
  ApiResult<AuthorFollowSummary>? getSummaryResult;

  String? lastTargetUserId;
  String? lastAuthorKey;
  String? lastViewerUserId;
  String? lastFollowerId;
  String? lastAuthorId;
  String? lastAuthorName;
  bool getSummaryCalled = false;
  bool followAuthorCalled = false;
  bool unfollowAuthorCalled = false;

  @override
  Future<ApiResult<AuthorFollowSummary>> getFollowSummary({
    String? targetUserId,
    String? authorKey,
    String? viewerUserId,
  }) async {
    getSummaryCalled = true;
    lastTargetUserId = targetUserId;
    lastAuthorKey = authorKey;
    lastViewerUserId = viewerUserId;
    return getSummaryResult ?? Success(summaryToReturn);
  }

  @override
  Future<ApiResult<void>> followAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
    String? authorName,
  }) async {
    followAuthorCalled = true;
    lastFollowerId = followerId;
    lastAuthorKey = authorKey;
    lastAuthorId = authorId;
    lastAuthorName = authorName;
    return followResult ?? const Success(null);
  }

  @override
  Future<ApiResult<void>> unfollowAuthor({
    required String followerId,
    required String authorKey,
    String? authorId,
  }) async {
    unfollowAuthorCalled = true;
    lastFollowerId = followerId;
    lastAuthorKey = authorKey;
    lastAuthorId = authorId;
    return unfollowResult ?? const Success(null);
  }
}

void main() {
  const validUuid1 = '123e4567-e89b-12d3-a456-426614174000';
  const validUuid2 = '987fcdeb-51a2-43d7-b890-123456789abc';

  group('AuthorFollowValidator', () {
    group('isValidUuid', () {
      test('returns true for standard lowercase, uppercase, and trimmed UUID', () {
        expect(AuthorFollowValidator.isValidUuid(validUuid1), isTrue);
        expect(AuthorFollowValidator.isValidUuid(validUuid1.toUpperCase()), isTrue);
        expect(AuthorFollowValidator.isValidUuid('  $validUuid1  '), isTrue);
      });

      test('returns false for null, empty, or non-UUID strings', () {
        expect(AuthorFollowValidator.isValidUuid(null), isFalse);
        expect(AuthorFollowValidator.isValidUuid(''), isFalse);
        expect(AuthorFollowValidator.isValidUuid('   '), isFalse);
        expect(AuthorFollowValidator.isValidUuid('editorial-staff'), isFalse);
      });
    });

    group('resolveAuthorKey', () {
      test('prefers valid lowercase UUID authorId over name/key', () {
        expect(
          AuthorFollowValidator.resolveAuthorKey(
            authorId: '  ${validUuid1.toUpperCase()}  ',
            authorName: 'Dr. Elena Rostova',
          ),
          equals(validUuid1),
        );
      });

      test('falls back to normalized authorKey or authorName for seeded authors', () {
        expect(
          AuthorFollowValidator.resolveAuthorKey(
            authorId: null,
            authorName: '  Dr. Elena Rostova  ',
          ),
          equals('dr. elena rostova'),
        );
        expect(
          AuthorFollowValidator.resolveAuthorKey(
            authorId: null,
            authorKey: '  Wade Warren  ',
          ),
          equals('wade warren'),
        );
      });
    });

    group('isSelf', () {
      test('detects matching UUIDs via authorId or authorKey', () {
        expect(
          AuthorFollowValidator.isSelf(
            authorId: '  $validUuid1  ',
            viewerUserId: validUuid1.toUpperCase(),
          ),
          isTrue,
        );
        expect(
          AuthorFollowValidator.isSelf(
            authorId: null,
            authorKey: validUuid1,
            viewerUserId: validUuid1,
          ),
          isTrue,
        );
      });

      test('returns false for different UUIDs or seeded author keys', () {
        expect(
          AuthorFollowValidator.isSelf(
            authorId: validUuid1,
            viewerUserId: validUuid2,
          ),
          isFalse,
        );
        expect(
          AuthorFollowValidator.isSelf(
            authorId: null,
            authorKey: 'dr. elena rostova',
            viewerUserId: validUuid1,
          ),
          isFalse,
        );
      });
    });

    group('canShowFollowButton', () {
      test('returns true for another UUID author and for seeded editorial authors', () {
        expect(
          AuthorFollowValidator.canShowFollowButton(
            authorId: validUuid1,
            viewerUserId: validUuid2,
          ),
          isTrue,
        );
        expect(
          AuthorFollowValidator.canShowFollowButton(
            authorId: null,
            authorName: 'Dr. Elena Rostova',
            viewerUserId: validUuid2,
          ),
          isTrue,
        );
      });

      test('returns false when viewing self or when author identity is completely empty', () {
        expect(
          AuthorFollowValidator.canShowFollowButton(
            authorId: validUuid1,
            viewerUserId: validUuid1,
          ),
          isFalse,
        );
        expect(
          AuthorFollowValidator.canShowFollowButton(
            authorId: null,
            authorName: '   ',
            viewerUserId: validUuid2,
          ),
          isFalse,
        );
      });
    });
  });

  group('GetAuthorFollowSummaryUseCase', () {
    late _FakeAuthorFollowRepository fakeRepo;
    late GetAuthorFollowSummaryUseCase useCase;

    setUp(() {
      fakeRepo = _FakeAuthorFollowRepository();
      useCase = GetAuthorFollowSummaryUseCase(fakeRepo);
    });

    test('returns empty AuthorFollowSummary without hitting repo when both targetUserId and authorKey/authorName are empty', () async {
      final result = await useCase(
        targetUserId: null,
        viewerUserId: validUuid2,
      );

      expect(fakeRepo.getSummaryCalled, isFalse);
      expect(result, isA<Success<AuthorFollowSummary>>());
      expect((result as Success<AuthorFollowSummary>).data, equals(const AuthorFollowSummary()));
    });

    test('fetches summary by canonical authorKey for seeded editorial authors', () async {
      const expectedSummary = AuthorFollowSummary(
        followersCount: 7,
        isFollowing: true,
      );
      fakeRepo.summaryToReturn = expectedSummary;

      final result = await useCase(
        targetUserId: null,
        authorName: 'Dr. Elena Rostova',
        viewerUserId: validUuid2,
      );

      expect(fakeRepo.getSummaryCalled, isTrue);
      expect(fakeRepo.lastTargetUserId, isNull);
      expect(fakeRepo.lastAuthorKey, equals('dr. elena rostova'));
      expect(fakeRepo.lastViewerUserId, equals(validUuid2));
      expect((result as Success<AuthorFollowSummary>).data, equals(expectedSummary));
    });

    test('delegates to repo passing trimmed targetUserId and viewerUserId for UUID authors', () async {
      const expectedSummary = AuthorFollowSummary(
        followersCount: 10,
        followingCount: 2,
        isFollowing: true,
      );
      fakeRepo.summaryToReturn = expectedSummary;

      final result = await useCase(
        targetUserId: '  $validUuid1  ',
        viewerUserId: '  $validUuid2  ',
      );

      expect(fakeRepo.getSummaryCalled, isTrue);
      expect(fakeRepo.lastTargetUserId, equals(validUuid1));
      expect(fakeRepo.lastAuthorKey, equals(validUuid1));
      expect(fakeRepo.lastViewerUserId, equals(validUuid2));
      expect((result as Success<AuthorFollowSummary>).data, equals(expectedSummary));
    });
  });

  group('ToggleAuthorFollowUseCase', () {
    late _FakeAuthorFollowRepository fakeRepo;
    late ToggleAuthorFollowUseCase useCase;

    setUp(() {
      fakeRepo = _FakeAuthorFollowRepository();
      useCase = ToggleAuthorFollowUseCase(fakeRepo);
    });

    test('rejects invalid or missing followerId with ValidationFailure', () async {
      final resultNull = await useCase(
        followerId: null,
        authorId: validUuid1,
        currentlyFollowing: false,
      );
      expect(resultNull, isA<FailureResult<AuthorFollowSummary>>());
      expect(
        (resultNull as FailureResult<AuthorFollowSummary>).failure.message,
        equals('Please sign in to follow authors'),
      );
    });

    test('rejects when both authorId and authorKey/authorName are empty', () async {
      final result = await useCase(
        followerId: validUuid1,
        authorId: null,
        authorName: '   ',
        currentlyFollowing: false,
      );
      expect(result, isA<FailureResult<AuthorFollowSummary>>());
      expect(
        (result as FailureResult<AuthorFollowSummary>).failure.message,
        equals('Author profile cannot be followed'),
      );
    });

    test('rejects self-follow with ValidationFailure', () async {
      final result = await useCase(
        followerId: validUuid1,
        authorId: validUuid1,
        currentlyFollowing: false,
      );
      expect(result, isA<FailureResult<AuthorFollowSummary>>());
      expect(
        (result as FailureResult<AuthorFollowSummary>).failure.message,
        equals('You cannot follow your own profile'),
      );
    });

    test('follows and unfollows a seeded editorial author (null authorId) via canonical authorKey', () async {
      const followedSummary = AuthorFollowSummary(
        followersCount: 1,
        isFollowing: true,
      );
      fakeRepo.summaryToReturn = followedSummary;

      final followRes = await useCase(
        followerId: validUuid1,
        authorId: null,
        authorName: 'Dr. Elena Rostova',
        currentlyFollowing: false,
      );

      expect(fakeRepo.followAuthorCalled, isTrue);
      expect(fakeRepo.lastFollowerId, equals(validUuid1));
      expect(fakeRepo.lastAuthorId, isNull);
      expect(fakeRepo.lastAuthorKey, equals('dr. elena rostova'));
      expect(fakeRepo.lastAuthorName, equals('Dr. Elena Rostova'));
      expect((followRes as Success<AuthorFollowSummary>).data, equals(followedSummary));

      const unfollowedSummary = AuthorFollowSummary(
        followersCount: 0,
        isFollowing: false,
      );
      fakeRepo.summaryToReturn = unfollowedSummary;

      final unfollowRes = await useCase(
        followerId: validUuid1,
        authorId: null,
        authorName: 'Dr. Elena Rostova',
        currentlyFollowing: true,
      );

      expect(fakeRepo.unfollowAuthorCalled, isTrue);
      expect(fakeRepo.lastAuthorKey, equals('dr. elena rostova'));
      expect((unfollowRes as Success<AuthorFollowSummary>).data, equals(unfollowedSummary));
    });

    test('follows and unfollows a UUID user author', () async {
      const refreshedSummary = AuthorFollowSummary(
        followersCount: 1,
        isFollowing: true,
      );
      fakeRepo.summaryToReturn = refreshedSummary;

      final result = await useCase(
        followerId: '  $validUuid1  ',
        authorId: '  $validUuid2  ',
        authorName: 'Grace Hopper',
        currentlyFollowing: false,
      );

      expect(fakeRepo.followAuthorCalled, isTrue);
      expect(fakeRepo.lastFollowerId, equals(validUuid1));
      expect(fakeRepo.lastAuthorId, equals(validUuid2));
      expect(fakeRepo.lastAuthorKey, equals(validUuid2));
      expect((result as Success<AuthorFollowSummary>).data, equals(refreshedSummary));
    });
  });

  group('AuthorFollowRepositoryImpl', () {
    late _FakeNetworkInfo fakeNetworkInfo;
    late _FakeAuthorFollowRemoteDataSource fakeRemoteDataSource;
    late AuthorFollowRepositoryImpl repository;

    setUp(() {
      fakeNetworkInfo = _FakeNetworkInfo(isConnectedValue: true);
      fakeRemoteDataSource = _FakeAuthorFollowRemoteDataSource();
      repository = AuthorFollowRepositoryImpl(
        remoteDataSource: fakeRemoteDataSource,
        networkInfo: fakeNetworkInfo,
      );
    });

    test('returns ServerFailure(You are Offline) when offline', () async {
      fakeNetworkInfo.isConnectedValue = false;

      final getRes = await repository.getFollowSummary(
        targetUserId: validUuid1,
        authorKey: validUuid1,
      );
      expect((getRes as FailureResult).failure.message, equals('You are Offline'));

      final followRes = await repository.followAuthor(
        followerId: validUuid1,
        authorKey: 'dr. elena rostova',
      );
      expect((followRes as FailureResult).failure.message, equals('You are Offline'));
    });

    test('delegates followAuthor and unfollowAuthor with authorKey online', () async {
      final followRes = await repository.followAuthor(
        followerId: validUuid1,
        authorKey: 'dr. elena rostova',
        authorName: 'Dr. Elena Rostova',
      );
      expect(followRes, isA<Success<void>>());
      expect(fakeRemoteDataSource.lastAuthorKey, equals('dr. elena rostova'));
      expect(fakeRemoteDataSource.lastAuthorName, equals('Dr. Elena Rostova'));

      final unfollowRes = await repository.unfollowAuthor(
        followerId: validUuid1,
        authorKey: 'dr. elena rostova',
      );
      expect(unfollowRes, isA<Success<void>>());
      expect(fakeRemoteDataSource.unfollowAuthorCalled, isTrue);
    });
  });
}
