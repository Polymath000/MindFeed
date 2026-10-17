import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_error_handler.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/networking/network_info.dart';
import 'package:mind_feed/features/home/data/datasources/articles_remote_data_source.dart';
import 'package:mind_feed/features/home/domain/entities/article_entity.dart';
import 'package:mind_feed/features/home/domain/entities/category_entity.dart';
import 'package:mind_feed/features/home/domain/entities/tag_entity.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';

import 'package:mind_feed/features/home/data/datasources/articles_local_data_source.dart';

class ArticlesRepositoryImpl implements ArticlesRepository, ArticleEngagementRepository {
  final ArticlesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final ArticlesLocalDataSource? localDataSource;

  ArticlesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    this.localDataSource,
  });

  @override
  Future<ApiResult<List<ArticleEntity>>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getHomeFeed(
          preferredCategoryIds: preferredCategoryIds,
          limit: limit,
          offset: offset,
        );
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<ArticleEntity>> getArticleById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getArticleById(id);
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getArticlesByCategory(
          categoryId,
          limit: limit,
          offset: offset,
        );
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getArticlesByAuthor(
          authorId,
          limit: limit,
          offset: offset,
        );
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.searchArticles(
          query,
          limit: limit,
          offset: offset,
        );
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCategories();
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<List<TagEntity>>> getFixedTags() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getFixedTags();
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<void>> starArticle(String articleId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.starArticle(articleId, userId);
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<void>> unstarArticle(String articleId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.unstarArticle(articleId, userId);
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<bool>> isArticleStarred(String articleId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.isArticleStarred(articleId, userId);
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<void>> saveBookmark(String articleId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.saveBookmark(articleId, userId);
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<void>> removeBookmark(String articleId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.removeBookmark(articleId, userId);
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<List<ArticleEntity>>> getSavedArticles(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSavedArticles(userId);
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<bool>> isArticleSaved(String articleId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.isArticleSaved(articleId, userId);
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<ArticleEntity>> saveDraft(Map<String, dynamic> draftData) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.saveDraft(draftData);
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<ArticleEntity>> publishArticle(String articleId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.publishArticle(articleId);
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<ArticleEntity>> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateArticle(articleId, updates);
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<void>> deleteArticle(String articleId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteArticle(articleId);
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<void> clearDownloadedArticles() async {
    if (localDataSource != null) {
      await localDataSource!.clearAllDownloadedArticles();
    }
  }

  @override
  Future<ApiResult<void>> likeArticle(String articleId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.likeArticle(articleId, userId);
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<void>> unlikeArticle(String articleId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.unlikeArticle(articleId, userId);
        return const Success(null);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<bool>> isArticleLiked(String articleId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.isArticleLiked(articleId, userId);
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<AuthorRatingSummary>> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.rateAuthor(
          authorKey: authorKey,
          stars: stars,
          authorId: authorId,
          authorName: authorName,
        );
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<AuthorRatingSummary>> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAuthorRatingSummary(
          authorKey: authorKey,
          authorId: authorId,
          authorName: authorName,
        );
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }
}
