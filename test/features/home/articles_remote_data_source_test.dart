import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/networking/network_info.dart';
import 'package:mind_feed/core/articles/data/datasources/articles_remote_data_source.dart';
import 'package:mind_feed/core/articles/data/repos/articles_repo_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockNetworkInfo implements NetworkInfo {
  final bool connected;
  MockNetworkInfo({this.connected = true});

  @override
  Future<bool> get isConnected async => connected;
}

class FakeUser extends Fake implements User {
  final String _id;
  FakeUser(this._id);

  @override
  String get id => _id;
}

class FakeGoTrueClient extends Fake implements GoTrueClient {
  User? currentUserValue;

  FakeGoTrueClient(this.currentUserValue);

  @override
  User? get currentUser => currentUserValue;
}

class RecordedUpsertCall {
  final String table;
  final dynamic values;
  final String? onConflict;
  final bool ignoreDuplicates;

  RecordedUpsertCall({
    required this.table,
    required this.values,
    this.onConflict,
    required this.ignoreDuplicates,
  });
}

class FakePostgrestTransformBuilder<T> extends Fake implements PostgrestTransformBuilder<T> {
  @override
  Future<U> then<U>(FutureOr<U> Function(T value) onValue, {Function? onError}) {
    return Future<T>.value(<Map<String, dynamic>>[] as T).then(onValue, onError: onError);
  }
}

class FakePostgrestFilterBuilder<T> extends Fake implements PostgrestFilterBuilder<T> {
  @override
  Future<U> then<U>(FutureOr<U> Function(T value) onValue, {Function? onError}) {
    return Future<T>.value(<Map<String, dynamic>>[] as T).then(onValue, onError: onError);
  }
}

class FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final String table;
  final List<RecordedUpsertCall> recordedUpserts;

  FakeSupabaseQueryBuilder(this.table, this.recordedUpserts);

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> upsert(
    dynamic values, {
    String? onConflict,
    bool ignoreDuplicates = false,
    bool defaultToNull = true,
  }) {
    recordedUpserts.add(
      RecordedUpsertCall(
        table: table,
        values: values,
        onConflict: onConflict,
        ignoreDuplicates: ignoreDuplicates,
      ),
    );
    return FakePostgrestFilterBuilder<List<Map<String, dynamic>>>();
  }
}

class FakeTestSupabaseClient extends Fake implements SupabaseClient {
  final FakeGoTrueClient authClient;
  final List<RecordedUpsertCall> recordedUpserts = [];

  FakeTestSupabaseClient(this.authClient);

  @override
  GoTrueClient get auth => authClient;

  @override
  SupabaseQueryBuilder from(String table) {
    return FakeSupabaseQueryBuilder(table, recordedUpserts);
  }
}

void main() {
  group('ArticlesRemoteDataSourceImpl authentication and upsert safety', () {
    test('saveBookmark throws StateError when user is not authenticated', () async {
      final authClient = FakeGoTrueClient(null);
      final client = FakeTestSupabaseClient(authClient);
      final dataSource = ArticlesRemoteDataSourceImpl(supabaseClient: client);

      expect(
        () => dataSource.saveBookmark('art-1', 'user-123'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'An authenticated session for the requested user is required.',
          ),
        ),
      );
      expect(client.recordedUpserts, isEmpty);
    });

    test('saveBookmark throws StateError when userId mismatches currentUser.id', () async {
      final authClient = FakeGoTrueClient(FakeUser('user-real'));
      final client = FakeTestSupabaseClient(authClient);
      final dataSource = ArticlesRemoteDataSourceImpl(supabaseClient: client);

      expect(
        () => dataSource.saveBookmark('art-1', 'user-imposter'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'An authenticated session for the requested user is required.',
          ),
        ),
      );
      expect(client.recordedUpserts, isEmpty);
    });

    test('saveBookmark executes upsert with ignoreDuplicates: true when authenticated', () async {
      final authClient = FakeGoTrueClient(FakeUser('user-123'));
      final client = FakeTestSupabaseClient(authClient);
      final dataSource = ArticlesRemoteDataSourceImpl(supabaseClient: client);

      await dataSource.saveBookmark('art-99', 'user-123');

      expect(client.recordedUpserts, hasLength(1));
      final call = client.recordedUpserts.first;
      expect(call.table, 'saved_articles');
      expect(call.values, {'user_id': 'user-123', 'article_id': 'art-99'});
      expect(call.onConflict, 'user_id,article_id');
      expect(call.ignoreDuplicates, isTrue);
    });

    test('likeArticle throws StateError when user is not authenticated', () async {
      final authClient = FakeGoTrueClient(null);
      final client = FakeTestSupabaseClient(authClient);
      final dataSource = ArticlesRemoteDataSourceImpl(supabaseClient: client);

      expect(
        () => dataSource.likeArticle('art-1', 'user-123'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'An authenticated session for the requested user is required.',
          ),
        ),
      );
      expect(client.recordedUpserts, isEmpty);
    });

    test('likeArticle throws StateError when userId mismatches currentUser.id', () async {
      final authClient = FakeGoTrueClient(FakeUser('user-real'));
      final client = FakeTestSupabaseClient(authClient);
      final dataSource = ArticlesRemoteDataSourceImpl(supabaseClient: client);

      expect(
        () => dataSource.likeArticle('art-1', 'user-imposter'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'An authenticated session for the requested user is required.',
          ),
        ),
      );
      expect(client.recordedUpserts, isEmpty);
    });

    test('likeArticle executes upsert with ignoreDuplicates: true when authenticated', () async {
      final authClient = FakeGoTrueClient(FakeUser('user-123'));
      final client = FakeTestSupabaseClient(authClient);
      final dataSource = ArticlesRemoteDataSourceImpl(supabaseClient: client);

      await dataSource.likeArticle('art-99', 'user-123');

      expect(client.recordedUpserts, hasLength(1));
      final call = client.recordedUpserts.first;
      expect(call.table, 'article_likes');
      expect(call.values, {'user_id': 'user-123', 'article_id': 'art-99'});
      expect(call.onConflict, 'user_id,article_id');
      expect(call.ignoreDuplicates, isTrue);
    });

    test('ArticlesRepositoryImpl maps StateError to FailureResult with authentication message', () async {
      final authClient = FakeGoTrueClient(null);
      final client = FakeTestSupabaseClient(authClient);
      final dataSource = ArticlesRemoteDataSourceImpl(supabaseClient: client);
      final repo = ArticlesRepositoryImpl(
        remoteDataSource: dataSource,
        networkInfo: MockNetworkInfo(connected: true),
      );

      final bookmarkResult = await repo.saveBookmark('art-1', 'user-1');
      bookmarkResult.when(
        success: (_) => fail('Should have failed'),
        failure: (f) {
          expect(f.message, 'An authenticated session for the requested user is required.');
        },
      );

      final likeResult = await repo.likeArticle('art-1', 'user-1');
      likeResult.when(
        success: (_) => fail('Should have failed'),
        failure: (f) {
          expect(f.message, 'An authenticated session for the requested user is required.');
        },
      );
    });
  });
}
