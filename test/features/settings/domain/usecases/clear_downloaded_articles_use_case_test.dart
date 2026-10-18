import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/settings/domain/usecases/clear_downloaded_articles_use_case.dart';

class _FakeOfflineArticlesRepository extends Fake implements OfflineArticlesRepository {
  bool clearAllCalled = false;
  bool shouldThrow = false;

  @override
  Future<void> clearAllDownloadedArticles() async {
    if (shouldThrow) {
      throw Exception('clear failed');
    }
    clearAllCalled = true;
  }
}

void main() {
  group('ClearDownloadedArticlesUseCase', () {
    test('clears all downloaded articles via OfflineArticlesRepository successfully', () async {
      final fakeOfflineRepo = _FakeOfflineArticlesRepository();
      final useCase = ClearDownloadedArticlesUseCase(fakeOfflineRepo);

      final result = await useCase();
      expect(result, isA<Success<void>>());
      expect(fakeOfflineRepo.clearAllCalled, isTrue);
    });

    test('returns FailureResult when repository throws exception', () async {
      final fakeOfflineRepo = _FakeOfflineArticlesRepository()..shouldThrow = true;
      final useCase = ClearDownloadedArticlesUseCase(fakeOfflineRepo);

      final result = await useCase();
      expect(result, isA<FailureResult<void>>());
    });
  });
}
