import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/articles/data/datasources/author_follow_remote_data_source.dart';
import 'package:mind_feed/core/articles/data/repos/author_follow_repo_impl.dart';
import 'package:mind_feed/core/articles/domain/entities/author_follow_summary.dart';
import 'package:mind_feed/core/articles/domain/repos/author_follow_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/author_follow_use_cases.dart';
import 'package:mind_feed/core/errors/failures.dart';
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
  String? lastViewerUserId;
  String? lastFollowerId;
  String? lastAuthorId;
  bool followAuthorCalled = false;
  bool unfollowAuthorCalled = false;

  @override
  Future<AuthorFollowSummary> getFollowSummary({
    required String targetUserId,
    String? viewerUserId,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    lastTargetUserId = targetUserId;
    lastViewerUserId = viewerUserId;
    return summaryToReturn;
  }

  @override
  Future<void> followAuthor({
    required String followerId,
    required String authorId,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    followAuthorCalled = true;
    lastFollowerId = followerId;
    lastAuthorId = authorId;
  }

  @override
  Future<void> unfollowAuthor({
    required String followerId,
    required String authorId,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    unfollowAuthorCalled = true;
    lastFollowerId = followerId;
    lastAuthorId = authorId;
  }
}

class _FakeAuthorFollowRepository implements AuthorFollowRepository {
  AuthorFollowSummary summaryToReturn = const AuthorFollowSummary();
  ApiResult<void>? followResult;
  ApiResult<void>? unfollowResult;
  ApiResult<AuthorFollowSummary>? getSummaryResult;

  String? lastTargetUserId;
  String? lastViewerUserId;
  String? lastFollowerId;
  String? lastAuthorId;
  bool getSummaryCalled = false;
  bool followAuthorCalled = false;
  bool unfollowAuthorCalled = false;

  @override
  Future<ApiResult<AuthorFollowSummary>> getFollowSummary({
    required String targetUserId,
    String? viewerUserId,
  }) async {
    getSummaryCalled = true;
    lastTargetUserId = targetUserId;
    lastViewerUserId = viewerUserId;
    return getSummaryResult ?? Success(summaryToReturn);
  }

  @override
  Future<ApiResult<void>> followAuthor({
    required String followerId,
    required String authorId,
  }) async {
    followAuthorCalled = true;
    lastFollowerId = followerId;
    lastAuthorId = authorId;
    return followResult ?? const Success(null);
  }

  @override
  Future<ApiResult<void>> unfollowAuthor({
    required String followerId,
    required String authorId,
  }) async {
    unfollowAuthorCalled = true;
    lastFollowerId = followerId;
    lastAuthorId = authorId;
    return unfollowResult ?? const Success(null);
  }
}

void main() {
  const validUuid1 = '123e4567-e89b-12d3-a456-426614174000';
  const validUuid2 = '987fcdeb-51a2-43d7-b890-123456789abc';

  group('AuthorFollowValidator', () {
    group('isValidUuid', () {
      test('returns true for standard lowercase UUID', () {
        expect(AuthorFollowValidator.isValidUuid(validUuid1), isTrue);
      });

      test('returns true for uppercase UUID and trimmed UUID', () {
        expect(
          AuthorFollowValidator.isValidUuid(validUuid1.toUpperCase()),
          isTrue,
        );
        expect(
          AuthorFollowValidator.isValidUuid('  $validUuid1  '),
          isTrue,
        );
      });

      test('returns false for null', () {
        expect(AuthorFollowValidator.isValidUuid(null), isFalse);
      });

      test('returns false for empty string and whitespace', () {
        expect(AuthorFollowValidator.isValidUuid(''), isFalse);
        expect(AuthorFollowValidator.isValidUuid('   '), isFalse);
      });

      test('returns false for seeded slugs like editorial-staff', () {
        expect(AuthorFollowValidator.isValidUuid('editorial-staff'), isFalse);
      });

      test('returns false for invalid formatting', () {
        expect(AuthorFollowValidator.isValidUuid('not-a-valid-uuid'), isFalse);
        expect(
          AuthorFollowValidator.isValidUuid('123e4567-e89b-12d3-a456-42661417400'),
          isFalse,
        );
        expect(
          AuthorFollowValidator.isValidUuid('123e4567e89b12d3a456426614174000'),
          isFalse,
        );
      });
    });

    group('isSelf', () {
      test('detects matching UUIDs with exact match', () {
        expect(
          AuthorFollowValidator.isSelf(
            authorId: validUuid1,
            viewerUserId: validUuid1,
          ),
          isTrue,
        );
      });

      test('detects matching UUIDs with case differences and whitespace', () {
        expect(
          AuthorFollowValidator.isSelf(
            authorId: '  $validUuid1  ',
            viewerUserId: validUuid1.toUpperCase(),
          ),
          isTrue,
        );
      });

      test('returns false for different UUIDs', () {
        expect(
          AuthorFollowValidator.isSelf(
            authorId: validUuid1,
            viewerUserId: validUuid2,
          ),
          isFalse,
        );
      });

      test('returns false when authorId or viewerUserId is empty or null', () {
        expect(
          AuthorFollowValidator.isSelf(authorId: null, viewerUserId: validUuid1),
          isFalse,
        );
        expect(
          AuthorFollowValidator.isSelf(authorId: validUuid1, viewerUserId: null),
          isFalse,
        );
        expect(
          AuthorFollowValidator.isSelf(authorId: '', viewerUserId: ''),
          isFalse,
        );
        expect(
          AuthorFollowValidator.isSelf(authorId: '   ', viewerUserId: '   '),
          isFalse,
        );
      });
    });

    group('canShowFollowButton', () {
      test('returns true only when authorId is valid UUID and not self', () {
        expect(
          AuthorFollowValidator.canShowFollowButton(
            authorId: validUuid1,
            viewerUserId: validUuid2,
          ),
          isTrue,
        );
        expect(
          AuthorFollowValidator.canShowFollowButton(
            authorId: validUuid1,
            viewerUserId: null,
          ),
          isTrue,
        );
      });

      test('returns false when authorId matches viewerUserId (self)', () {
        expect(
          AuthorFollowValidator.canShowFollowButton(
            authorId: validUuid1,
            viewerUserId: validUuid1,
          ),
          isFalse,
        );
      });

      test('returns false when authorId is not a valid UUID', () {
        expect(
          AuthorFollowValidator.canShowFollowButton(
            authorId: 'editorial-staff',
            viewerUserId: validUuid2,
          ),
          isFalse,
        );
        expect(
          AuthorFollowValidator.canShowFollowButton(
            authorId: null,
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

    test('returns empty AuthorFollowSummary without hitting repo when targetUserId is null', () async {
      final result = await useCase(
        targetUserId: null,
        viewerUserId: validUuid2,
      );

      expect(fakeRepo.getSummaryCalled, isFalse);
      expect(result, isA<Success<AuthorFollowSummary>>());
      final summary = (result as Success<AuthorFollowSummary>).data;
      expect(summary, equals(const AuthorFollowSummary()));
    });

    test('returns empty AuthorFollowSummary without hitting repo when targetUserId is non-UUID', () async {
      final result = await useCase(
        targetUserId: 'editorial-staff',
        viewerUserId: validUuid2,
      );

      expect(fakeRepo.getSummaryCalled, isFalse);
      expect(result, isA<Success<AuthorFollowSummary>>());
      final summary = (result as Success<AuthorFollowSummary>).data;
      expect(summary, equals(const AuthorFollowSummary()));
    });

    test('delegates to repo passing null for viewerUserId if viewerUserId is non-UUID', () async {
      const expectedSummary = AuthorFollowSummary(
        followersCount: 5,
        followingCount: 3,
        isFollowing: false,
      );
      fakeRepo.summaryToReturn = expectedSummary;

      final result = await useCase(
        targetUserId: '  $validUuid1  ',
        viewerUserId: 'editorial-staff',
      );

      expect(fakeRepo.getSummaryCalled, isTrue);
      expect(fakeRepo.lastTargetUserId, equals(validUuid1));
      expect(fakeRepo.lastViewerUserId, isNull);
      expect(result, isA<Success<AuthorFollowSummary>>());
      expect((result as Success<AuthorFollowSummary>).data, equals(expectedSummary));
    });

    test('delegates to repo passing trimmed viewerUserId when viewerUserId is a valid UUID', () async {
      const expectedSummary = AuthorFollowSummary(
        followersCount: 10,
        followingCount: 2,
        isFollowing: true,
      );
      fakeRepo.summaryToReturn = expectedSummary;

      final result = await useCase(
        targetUserId: validUuid1,
        viewerUserId: '  $validUuid2  ',
      );

      expect(fakeRepo.getSummaryCalled, isTrue);
      expect(fakeRepo.lastTargetUserId, equals(validUuid1));
      expect(fakeRepo.lastViewerUserId, equals(validUuid2));
      expect(result, isA<Success<AuthorFollowSummary>>());
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
      final failureNull = (resultNull as FailureResult<AuthorFollowSummary>).failure;
      expect(failureNull, isA<ValidationFailure>());
      expect(failureNull.message, equals('Please sign in to follow authors'));

      final resultInvalid = await useCase(
        followerId: 'invalid-follower',
        authorId: validUuid1,
        currentlyFollowing: false,
      );
      expect(resultInvalid, isA<FailureResult<AuthorFollowSummary>>());
      final failureInvalid = (resultInvalid as FailureResult<AuthorFollowSummary>).failure;
      expect(failureInvalid, isA<ValidationFailure>());
      expect(failureInvalid.message, equals('Please sign in to follow authors'));
      expect(fakeRepo.followAuthorCalled, isFalse);
    });

    test('rejects invalid or missing authorId with ValidationFailure', () async {
      final resultNull = await useCase(
        followerId: validUuid1,
        authorId: null,
        currentlyFollowing: false,
      );
      expect(resultNull, isA<FailureResult<AuthorFollowSummary>>());
      final failureNull = (resultNull as FailureResult<AuthorFollowSummary>).failure;
      expect(failureNull, isA<ValidationFailure>());
      expect(failureNull.message, equals('Author profile cannot be followed'));

      final resultInvalid = await useCase(
        followerId: validUuid1,
        authorId: 'editorial-staff',
        currentlyFollowing: false,
      );
      expect(resultInvalid, isA<FailureResult<AuthorFollowSummary>>());
      final failureInvalid = (resultInvalid as FailureResult<AuthorFollowSummary>).failure;
      expect(failureInvalid, isA<ValidationFailure>());
      expect(failureInvalid.message, equals('Author profile cannot be followed'));
      expect(fakeRepo.followAuthorCalled, isFalse);
    });

    test('rejects self-follow with ValidationFailure', () async {
      final result = await useCase(
        followerId: validUuid1,
        authorId: validUuid1,
        currentlyFollowing: false,
      );
      expect(result, isA<FailureResult<AuthorFollowSummary>>());
      final failure = (result as FailureResult<AuthorFollowSummary>).failure;
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, equals('You cannot follow your own profile'));
      expect(fakeRepo.followAuthorCalled, isFalse);
    });

    test('calls followAuthor when currentlyFollowing is false and returns refreshed summary', () async {
      const refreshedSummary = AuthorFollowSummary(
        followersCount: 1,
        followingCount: 0,
        isFollowing: true,
      );
      fakeRepo.summaryToReturn = refreshedSummary;

      final result = await useCase(
        followerId: '  $validUuid1  ',
        authorId: '  $validUuid2  ',
        currentlyFollowing: false,
      );

      expect(fakeRepo.followAuthorCalled, isTrue);
      expect(fakeRepo.lastFollowerId, equals(validUuid1));
      expect(fakeRepo.lastAuthorId, equals(validUuid2));
      expect(fakeRepo.getSummaryCalled, isTrue);
      expect(fakeRepo.lastTargetUserId, equals(validUuid2));
      expect(fakeRepo.lastViewerUserId, equals(validUuid1));
      expect(result, isA<Success<AuthorFollowSummary>>());
      expect((result as Success<AuthorFollowSummary>).data, equals(refreshedSummary));
    });

    test('calls unfollowAuthor when currentlyFollowing is true and returns refreshed summary', () async {
      const refreshedSummary = AuthorFollowSummary(
        followersCount: 0,
        followingCount: 0,
        isFollowing: false,
      );
      fakeRepo.summaryToReturn = refreshedSummary;

      final result = await useCase(
        followerId: '  $validUuid1  ',
        authorId: '  $validUuid2  ',
        currentlyFollowing: true,
      );

      expect(fakeRepo.unfollowAuthorCalled, isTrue);
      expect(fakeRepo.lastFollowerId, equals(validUuid1));
      expect(fakeRepo.lastAuthorId, equals(validUuid2));
      expect(fakeRepo.getSummaryCalled, isTrue);
      expect(fakeRepo.lastTargetUserId, equals(validUuid2));
      expect(fakeRepo.lastViewerUserId, equals(validUuid1));
      expect(result, isA<Success<AuthorFollowSummary>>());
      expect((result as Success<AuthorFollowSummary>).data, equals(refreshedSummary));
    });

    test('returns failure if followAuthor fails without getting summary', () async {
      fakeRepo.followResult = const FailureResult(ServerFailure('Follow failed'));

      final result = await useCase(
        followerId: validUuid1,
        authorId: validUuid2,
        currentlyFollowing: false,
      );

      expect(fakeRepo.followAuthorCalled, isTrue);
      expect(fakeRepo.getSummaryCalled, isFalse);
      expect(result, isA<FailureResult<AuthorFollowSummary>>());
      expect(
        (result as FailureResult<AuthorFollowSummary>).failure.message,
        equals('Follow failed'),
      );
    });

    test('returns failure if unfollowAuthor fails without getting summary', () async {
      fakeRepo.unfollowResult = const FailureResult(ServerFailure('Unfollow failed'));

      final result = await useCase(
        followerId: validUuid1,
        authorId: validUuid2,
        currentlyFollowing: true,
      );

      expect(fakeRepo.unfollowAuthorCalled, isTrue);
      expect(fakeRepo.getSummaryCalled, isFalse);
      expect(result, isA<FailureResult<AuthorFollowSummary>>());
      expect(
        (result as FailureResult<AuthorFollowSummary>).failure.message,
        equals('Unfollow failed'),
      );
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

    group('offline state', () {
      setUp(() {
        fakeNetworkInfo.isConnectedValue = false;
      });

      test('getFollowSummary returns ServerFailure(You are Offline) when offline', () async {
        final result = await repository.getFollowSummary(
          targetUserId: validUuid1,
          viewerUserId: validUuid2,
        );

        expect(result, isA<FailureResult<AuthorFollowSummary>>());
        final failure = (result as FailureResult<AuthorFollowSummary>).failure;
        expect(failure, isA<ServerFailure>());
        expect(failure.message, equals('You are Offline'));
      });

      test('followAuthor returns ServerFailure(You are Offline) when offline', () async {
        final result = await repository.followAuthor(
          followerId: validUuid1,
          authorId: validUuid2,
        );

        expect(result, isA<FailureResult<void>>());
        final failure = (result as FailureResult<void>).failure;
        expect(failure, isA<ServerFailure>());
        expect(failure.message, equals('You are Offline'));
      });

      test('unfollowAuthor returns ServerFailure(You are Offline) when offline', () async {
        final result = await repository.unfollowAuthor(
          followerId: validUuid1,
          authorId: validUuid2,
        );

        expect(result, isA<FailureResult<void>>());
        final failure = (result as FailureResult<void>).failure;
        expect(failure, isA<ServerFailure>());
        expect(failure.message, equals('You are Offline'));
      });
    });

    group('online state with successful operations', () {
      test('getFollowSummary maps remote data source result to Success', () async {
        const expectedSummary = AuthorFollowSummary(
          followersCount: 42,
          followingCount: 12,
          isFollowing: true,
        );
        fakeRemoteDataSource.summaryToReturn = expectedSummary;

        final result = await repository.getFollowSummary(
          targetUserId: validUuid1,
          viewerUserId: validUuid2,
        );

        expect(fakeRemoteDataSource.lastTargetUserId, equals(validUuid1));
        expect(fakeRemoteDataSource.lastViewerUserId, equals(validUuid2));
        expect(result, isA<Success<AuthorFollowSummary>>());
        expect((result as Success<AuthorFollowSummary>).data, equals(expectedSummary));
      });

      test('followAuthor calls remoteDataSource and returns Success(null)', () async {
        final result = await repository.followAuthor(
          followerId: validUuid1,
          authorId: validUuid2,
        );

        expect(fakeRemoteDataSource.followAuthorCalled, isTrue);
        expect(fakeRemoteDataSource.lastFollowerId, equals(validUuid1));
        expect(fakeRemoteDataSource.lastAuthorId, equals(validUuid2));
        expect(result, isA<Success<void>>());
      });

      test('unfollowAuthor calls remoteDataSource and returns Success(null)', () async {
        final result = await repository.unfollowAuthor(
          followerId: validUuid1,
          authorId: validUuid2,
        );

        expect(fakeRemoteDataSource.unfollowAuthorCalled, isTrue);
        expect(fakeRemoteDataSource.lastFollowerId, equals(validUuid1));
        expect(fakeRemoteDataSource.lastAuthorId, equals(validUuid2));
        expect(result, isA<Success<void>>());
      });
    });

    group('online state with exceptions', () {
      test('getFollowSummary maps exception to FailureResult', () async {
        fakeRemoteDataSource.errorToThrow = Exception('Remote call failed');

        final result = await repository.getFollowSummary(
          targetUserId: validUuid1,
        );

        expect(result, isA<FailureResult<AuthorFollowSummary>>());
        final failure = (result as FailureResult<AuthorFollowSummary>).failure;
        expect(failure, isA<ServerFailure>());
      });

      test('followAuthor maps exception to FailureResult', () async {
        fakeRemoteDataSource.errorToThrow = Exception('Remote call failed');

        final result = await repository.followAuthor(
          followerId: validUuid1,
          authorId: validUuid2,
        );

        expect(result, isA<FailureResult<void>>());
        final failure = (result as FailureResult<void>).failure;
        expect(failure, isA<ServerFailure>());
      });

      test('unfollowAuthor maps exception to FailureResult', () async {
        fakeRemoteDataSource.errorToThrow = Exception('Remote call failed');

        final result = await repository.unfollowAuthor(
          followerId: validUuid1,
          authorId: validUuid2,
        );

        expect(result, isA<FailureResult<void>>());
        final failure = (result as FailureResult<void>).failure;
        expect(failure, isA<ServerFailure>());
      });
    });
  });
}
