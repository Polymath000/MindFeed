import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/add_article/domain/helpers/article_payload_builder.dart';
import 'package:mind_feed/features/add_article/domain/helpers/article_validator.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/publish_article_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/save_draft_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/update_article_use_case.dart';

class AddArticleCubit extends Cubit<AddArticleState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetFixedTagsUseCase getFixedTagsUseCase;
  final SaveDraftUseCase saveDraftUseCase;
  final PublishArticleUseCase publishArticleUseCase;
  final UpdateArticleUseCase updateArticleUseCase;
  final CurrentUserSnapshot? Function()? userResolver;
  final ImageDimensionResolver? dimensionResolver;

  AddArticleCubit({
    GetCategoriesUseCase? getCategoriesUseCase,
    GetFixedTagsUseCase? getFixedTagsUseCase,
    SaveDraftUseCase? saveDraftUseCase,
    PublishArticleUseCase? publishArticleUseCase,
    UpdateArticleUseCase? updateArticleUseCase,
    this.userResolver,
    this.dimensionResolver,
  })  : getCategoriesUseCase =
            getCategoriesUseCase ?? getIt<GetCategoriesUseCase>(),
        getFixedTagsUseCase =
            getFixedTagsUseCase ?? getIt<GetFixedTagsUseCase>(),
        saveDraftUseCase = saveDraftUseCase ?? getIt<SaveDraftUseCase>(),
        publishArticleUseCase =
            publishArticleUseCase ?? getIt<PublishArticleUseCase>(),
        updateArticleUseCase =
            updateArticleUseCase ?? getIt<UpdateArticleUseCase>(),
        super(const AddArticleState());

  CurrentUserSnapshot? get _currentUser =>
      userResolver != null ? userResolver!() : CurrentUserSession.resolveCurrentUser();

  Future<void> initialize({EditorialNewsItem? editingItem}) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    final categoriesResult = await getCategoriesUseCase.call();
    final tagsResult = await getFixedTagsUseCase.call();
    final categories = categoriesResult.when(
      success: (list) => list,
      failure: (_) => state.categories,
    );
    final tags = tagsResult.when(
      success: (list) => list,
      failure: (_) => state.availableTags,
    );
    final editError = (editingItem != null &&
            editingItem.status == 'published' &&
            !editingItem.isEditableWithinWindow)
        ? 'Published articles can only be edited within 30 days of publication'
        : null;

    emit(state.copyWith(
      isLoading: false,
      categories: categories,
      availableTags: tags,
      title: editingItem?.title ?? state.title,
      content: editingItem?.content ?? state.content,
      coverImageUrl: editingItem?.coverImageUrl ?? state.coverImageUrl,
      selectedCategoryId: editingItem?.categoryId ?? state.selectedCategoryId,
      selectedTags: editingItem != null
          ? List<String>.from(editingItem.tags)
          : state.selectedTags,
      editingItemId: editingItem?.id ?? state.editingItemId,
      editingItemStatus: editingItem?.status ?? state.editingItemStatus,
      publishedAt: editingItem?.publishedAt ?? state.publishedAt,
      errorMessage: editError,
    ));
  }

  void onTitleChanged(String title) {
    emit(state.copyWith(
      title: title,
      formErrors: state.formErrors.copyWith(clearTitle: true),
      clearError: true,
      clearSuccess: true,
    ));
  }

  void onContentChanged(String content) {
    emit(state.copyWith(
      content: content,
      formErrors: state.formErrors.copyWith(clearContent: true),
      clearError: true,
      clearSuccess: true,
    ));
  }

  void onCoverImageUrlChanged(String url) {
    emit(state.copyWith(
      coverImageUrl: url,
      formErrors: state.formErrors.copyWith(clearCoverImageUrl: true),
      clearError: true,
      clearSuccess: true,
    ));
  }

  void onCategorySelected(String? categoryId) {
    emit(state.copyWith(
      selectedCategoryId: categoryId,
      formErrors: state.formErrors.copyWith(clearCategory: true),
      clearError: true,
      clearSuccess: true,
    ));
  }

  void onTagToggled(String tagName) {
    final currentTags = List<String>.from(state.selectedTags);
    if (currentTags.contains(tagName)) {
      currentTags.remove(tagName);
    } else if (currentTags.length < 5) {
      currentTags.add(tagName);
    } else {
      return;
    }
    emit(state.copyWith(
      selectedTags: currentTags,
      formErrors: state.formErrors.copyWith(clearTags: true),
      clearError: true,
      clearSuccess: true,
    ));
  }

  Future<void> saveDraft() async {
    if (state.isSavingDraft || state.isPublishing) return;
    final user = _currentUser;
    if (user == null || user.id == null) {
      emit(state.copyWith(errorMessage: 'User not authenticated', clearSuccess: true));
      return;
    }
    final draftTitleError = ArticleValidator.validateDraftTitle(state.title);
    if (draftTitleError != null) {
      emit(state.copyWith(
        formErrors: state.formErrors.copyWith(titleError: draftTitleError),
        errorMessage: draftTitleError,
        clearSuccess: true,
      ));
      return;
    }

    emit(state.copyWith(isSavingDraft: true, clearError: true, clearSuccess: true));
    final isExisting = state.editingItemId != null && state.editingItemId!.isNotEmpty;
    final payload = ArticlePayloadBuilder.buildDraftPayload(
      state: state,
      user: user,
      includeSlug: !isExisting,
    );

    final result = isExisting
        ? await updateArticleUseCase.call(
            articleId: state.editingItemId!,
            updates: payload,
            status: state.editingItemStatus,
            publishedAt: state.publishedAt,
          )
        : await saveDraftUseCase.call(payload);

    result.when(
      success: (article) => emit(state.copyWith(
        isSavingDraft: false,
        isSuccess: true,
        editingItemId: article.id,
        editingItemStatus: state.editingItemStatus.isNotEmpty
            ? state.editingItemStatus
            : 'draft',
        lastSavedArticle: article,
        successMessage: 'Draft saved successfully',
      )),
      failure: (f) => emit(state.copyWith(isSavingDraft: false, errorMessage: f.message)),
    );
  }

  Future<void> publish() async {
    if (state.isSavingDraft || state.isPublishing) return;
    final user = _currentUser;
    if (user == null || user.id == null) {
      emit(state.copyWith(errorMessage: 'User not authenticated', clearSuccess: true));
      return;
    }

    final errors = await ArticleValidator.validateForPublish(
      title: state.title,
      content: state.content,
      coverImageUrl: state.coverImageUrl,
      categoryId: state.selectedCategoryId,
      availableCategoryIds: state.categories.map((c) => c.id).toList(),
      tags: state.selectedTags,
      allowedTagNames: state.availableTags.map((t) => t.name).toList(),
      dimensionResolver: dimensionResolver,
    );
    if (errors.hasErrors) {
      emit(state.copyWith(
        formErrors: errors,
        errorMessage: 'Please correct validation errors before publishing',
        clearSuccess: true,
      ));
      return;
    }

    emit(state.copyWith(isPublishing: true, clearError: true, clearSuccess: true));
    final isNew = state.editingItemId == null || state.editingItemId!.isEmpty;
    final payload = ArticlePayloadBuilder.buildPublishPayload(
      state: state,
      user: user,
      includeSlug: isNew,
    );

    if (state.editingItemStatus == 'published') {
      final updateResult = await updateArticleUseCase.call(
        articleId: state.editingItemId!,
        updates: payload,
        status: 'published',
        publishedAt: state.publishedAt,
      );
      updateResult.when(
        success: (article) => emit(state.copyWith(
          isPublishing: false,
          isSuccess: true,
          lastSavedArticle: article,
          successMessage: 'Article updated successfully',
        )),
        failure: (f) => emit(state.copyWith(isPublishing: false, errorMessage: f.message)),
      );
      return;
    }

    String articleId = state.editingItemId ?? '';
    final prepResult = isNew
        ? await saveDraftUseCase.call(payload)
        : await updateArticleUseCase.call(
            articleId: articleId,
            updates: payload,
            status: 'draft',
          );

    final failed = prepResult.when(
      success: (article) {
        articleId = article.id;
        return false;
      },
      failure: (f) {
        emit(state.copyWith(isPublishing: false, errorMessage: f.message));
        return true;
      },
    );
    if (failed) return;

    final publishResult = await publishArticleUseCase.call(
      articleId: articleId,
      title: state.title,
      content: state.content,
    );
    publishResult.when(
      success: (article) => emit(state.copyWith(
        isPublishing: false,
        isSuccess: true,
        editingItemId: article.id,
        editingItemStatus: 'published',
        publishedAt: article.publishedAt ?? DateTime.now(),
        lastSavedArticle: article,
        successMessage: 'Article published successfully',
      )),
      failure: (f) => emit(state.copyWith(isPublishing: false, errorMessage: f.message)),
    );
  }
}
