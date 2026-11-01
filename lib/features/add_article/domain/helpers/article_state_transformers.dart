import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/add_article/domain/helpers/article_payload_builder.dart';
import 'package:mind_feed/features/add_article/domain/helpers/article_validator.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';

sealed class ArticleStateTransformers {
  static AddArticleState authError(AddArticleState state) => state.copyWith(
    errorMessage: 'User not authenticated',
    clearSuccess: true,
  );

  static AddArticleState draftTitleError(
    AddArticleState state,
    String titleErr,
  ) => state.copyWith(
    formErrors: state.formErrors.copyWith(titleError: titleErr),
    errorMessage: titleErr,
    clearSuccess: true,
  );

  static AddArticleState publishErrors(
    AddArticleState state,
    ArticleFormErrors errors,
  ) => state.copyWith(
    formErrors: errors,
    errorMessage: 'Please correct validation errors before publishing',
    clearSuccess: true,
  );

  static AddArticleState updateTitle(AddArticleState state, String title) =>
      state.copyWith(
        title: title,
        formErrors: state.formErrors.copyWith(clearTitle: true),
        clearError: true,
        clearSuccess: true,
      );

  static AddArticleState updateContent(AddArticleState state, String content) =>
      state.copyWith(
        content: content,
        formErrors: state.formErrors.copyWith(clearContent: true),
        clearError: true,
        clearSuccess: true,
      );

  static AddArticleState updateCoverImageUrl(
    AddArticleState state,
    String url,
  ) => state.copyWith(
    coverImageUrl: url,
    formErrors: state.formErrors.copyWith(clearCoverImageUrl: true),
    clearError: true,
    clearSuccess: true,
  );

  static AddArticleState selectCategory(
    AddArticleState state,
    String? categoryId,
  ) => state.copyWith(
    selectedCategoryId: categoryId,
    formErrors: state.formErrors.copyWith(clearCategory: true),
    clearError: true,
    clearSuccess: true,
  );

  static AddArticleState buildDraftSuccessState(
    AddArticleState state,
    ArticleEntity article,
  ) => state.copyWith(
    isSavingDraft: false,
    isSuccess: true,
    editingItemId: article.id,
    editingItemStatus: state.editingItemStatus.isNotEmpty
        ? state.editingItemStatus
        : 'draft',
    lastSavedArticle: article,
    successMessage: 'Draft saved successfully',
  );

  static AddArticleState buildPublishSuccessState(
    AddArticleState state,
    ArticleEntity article,
    String successMsg,
  ) => state.copyWith(
    isPublishing: false,
    isSuccess: true,
    editingItemId: article.id,
    editingItemStatus: 'published',
    publishedAt: article.publishedAt ?? DateTime.now(),
    lastSavedArticle: article,
    successMessage: successMsg,
  );

  static AddArticleState buildInitializedState({
    required AddArticleState state,
    required List<CategoryEntity> categories,
    required List<TagEntity> availableTags,
    EditorialNewsItem? editingItem,
  }) {
    final mergedAvailable = List<TagEntity>.from(availableTags);
    if (editingItem != null) {
      for (final tagName in editingItem.tags) {
        if (!mergedAvailable.any(
          (t) => t.name.toLowerCase() == tagName.toLowerCase(),
        )) {
          mergedAvailable.add(
            TagEntity(
              id: 'draft_${tagName.toLowerCase()}',
              name: tagName.toLowerCase(),
              slug: tagName.toLowerCase(),
            ),
          );
        }
      }
    }
    String? categoryId = editingItem?.categoryId ?? state.selectedCategoryId;
    if ((categoryId == null || categoryId.isEmpty) &&
        editingItem?.categorySlug != null) {
      final match = categories
          .where((c) => c.slug == editingItem!.categorySlug)
          .firstOrNull;
      categoryId = match?.id;
    }
    return state.copyWith(
      isLoading: false,
      categories: categories,
      availableTags: mergedAvailable,
      title: editingItem?.title ?? state.title,
      content: editingItem?.content ?? state.content,
      coverImageUrl: editingItem?.heroImageUrl ??
          editingItem?.coverImageUrl ??
          state.coverImageUrl,
      selectedCategoryId: categoryId,
      selectedTags: editingItem != null
          ? List<String>.from(editingItem.tags)
          : state.selectedTags,
      editingItemId: editingItem?.id ?? state.editingItemId,
      editingItemStatus: editingItem?.status ?? state.editingItemStatus,
      publishedAt: editingItem?.publishedAt ?? state.publishedAt,
      errorMessage: ArticlePayloadBuilder.resolveEditLockoutError(editingItem),
    );
  }

  static AddArticleState toggleTag(AddArticleState state, String tagName) {
    final tags = List<String>.from(state.selectedTags);
    if (!tags.remove(tagName) && tags.length < 5) tags.add(tagName);
    return state.copyWith(
      selectedTags: tags,
      formErrors: state.formErrors.copyWith(clearTags: true),
      clearError: true,
      clearSuccess: true,
    );
  }

  static AddArticleState applyCustomTag(AddArticleState state, String rawTag) {
    final normalized = rawTag
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'^#+'), '')
        .replaceAll(RegExp(r'\s+'), '-');
    if (normalized.isEmpty || normalized.length > 30) return state;
    final updatedAvailable = List<TagEntity>.from(state.availableTags);
    if (!updatedAvailable.any((t) => t.name.toLowerCase() == normalized)) {
      updatedAvailable.add(
        TagEntity(
          id: 'custom_${DateTime.now().millisecondsSinceEpoch}_$normalized',
          name: normalized,
          slug: normalized,
        ),
      );
    }
    final updatedSelected = List<String>.from(state.selectedTags);
    if (!updatedSelected.contains(normalized) && updatedSelected.length < 5) {
      updatedSelected.add(normalized);
    }
    return state.copyWith(
      availableTags: updatedAvailable,
      selectedTags: updatedSelected,
      formErrors: state.formErrors.copyWith(clearTags: true),
      clearError: true,
      clearSuccess: true,
    );
  }
}
