import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

class RateAuthorUseCase {
  final ArticleEngagementRepository repository;

  const RateAuthorUseCase(this.repository);

  Future<ApiResult<AuthorRatingSummary>> call({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    if (authorKey.trim().isEmpty && (authorId == null || authorId.trim().isEmpty)) {
      return const FailureResult(ServerFailure('Author key is required'));
    }
    if (stars < 1 || stars > 5) {
      return const FailureResult(
        ServerFailure('Author rating must be between 1 and 5 stars'),
      );
    }
    return repository.rateAuthor(
      authorKey: authorKey,
      stars: stars,
      authorId: authorId,
      authorName: authorName,
    );
  }
}

class GetAuthorRatingUseCase {
  final ArticleEngagementRepository repository;

  const GetAuthorRatingUseCase(this.repository);

  Future<ApiResult<AuthorRatingSummary>> call({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) {
    return repository.getAuthorRatingSummary(
      authorKey: authorKey,
      authorId: authorId,
      authorName: authorName,
    );
  }
}
