import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/add_article/domain/helpers/article_validator.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';

sealed class ArticlePayloadBuilder {
  static String resolveAuthorName(CurrentUserSnapshot user) {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    return user.email ?? 'Editorial Staff';
  }

  static Map<String, dynamic> buildDraftPayload({
    required AddArticleState state,
    required CurrentUserSnapshot user,
    required bool includeSlug,
  }) {
    final category = state.categories
        .where((c) => c.id == state.selectedCategoryId)
        .firstOrNull;
    final excerpt = ArticleValidator.generateExcerpt(state.content);
    final readingTime = ArticleValidator.computeReadingTime(state.content);

    final payload = <String, dynamic>{
      'title': state.title.trim(),
      'excerpt': excerpt.isNotEmpty ? excerpt : 'Draft excerpt',
      'content': state.content,
      'author_id': user.id!,
      'author_name': resolveAuthorName(user),
      'reading_time_minutes': readingTime,
      'tags': state.selectedTags,
    };

    if (category != null) {
      payload['category_id'] = category.id;
      payload['category_slug'] = category.slug;
    }
    if (state.coverImageUrl.trim().isNotEmpty) {
      payload['cover_image_url'] = state.coverImageUrl.trim();
    }
    if (includeSlug) {
      payload['slug'] = ArticleValidator.generateSlug(state.title);
    }
    return payload;
  }

  static Map<String, dynamic> buildPublishPayload({
    required AddArticleState state,
    required CurrentUserSnapshot user,
    required bool includeSlug,
  }) {
    final category = state.categories
        .firstWhere((c) => c.id == state.selectedCategoryId);
    final excerpt = ArticleValidator.generateExcerpt(state.content);
    final readingTime = ArticleValidator.computeReadingTime(state.content);

    final payload = <String, dynamic>{
      'title': state.title.trim(),
      'excerpt': excerpt,
      'content': state.content,
      'author_id': user.id!,
      'author_name': resolveAuthorName(user),
      'category_id': category.id,
      'category_slug': category.slug,
      'cover_image_url': state.coverImageUrl.trim(),
      'tags': state.selectedTags,
      'reading_time_minutes': readingTime,
    };
    if (includeSlug) {
      payload['slug'] = ArticleValidator.generateSlug(state.title);
    }
    return payload;
  }
}
