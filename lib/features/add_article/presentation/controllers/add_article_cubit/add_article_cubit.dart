import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/features/add_article/domain/helpers/article_validator.dart';
import 'package:mind_feed/features/add_article/domain/usecases/publish_article_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/save_draft_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/update_article_use_case.dart';
import 'package:mind_feed/features/add_article/domain/usecases/upload_article_cover_image_use_case.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/article_payload_builder.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/article_state_transformers.dart';

class AddArticleCubit extends Cubit<AddArticleState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetFixedTagsUseCase getFixedTagsUseCase;
  final SaveDraftUseCase saveDraftUseCase;
  final PublishArticleUseCase publishArticleUseCase;
  final UpdateArticleUseCase updateArticleUseCase;
  final UploadArticleCoverImageUseCase? uploadArticleCoverImageUseCase;
  final CurrentUserSnapshot? Function()? userResolver;
  final ImageDimensionResolver? dimensionResolver;
  final Future<({double width, double height})?> Function(Uint8List bytes)?
      bytesDimensionResolver;

  AddArticleCubit({
    required this.getCategoriesUseCase,
    required this.getFixedTagsUseCase,
    required this.saveDraftUseCase,
    required this.publishArticleUseCase,
    required this.updateArticleUseCase,
    this.uploadArticleCoverImageUseCase,
    this.userResolver,
    this.dimensionResolver,
    this.bytesDimensionResolver,
  }) : super(const AddArticleState());

  CurrentUserSnapshot? get _currentUser => userResolver != null
      ? userResolver!()
      : CurrentUserSession.resolveCurrentUser();

  Future<void> initialize({EditorialNewsItem? editingItem}) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    final catRes = await getCategoriesUseCase.call();
    final tagRes = await getFixedTagsUseCase.call();
    emit(
      ArticleStateTransformers.buildInitializedState(
        state: state,
        categories: catRes.when(
          success: (l) => l,
          failure: (_) => state.categories,
        ),
        availableTags: tagRes.when(
          success: (l) => l,
          failure: (_) => state.availableTags,
        ),
        editingItem: editingItem,
      ),
    );
  }

  void onTitleChanged(String title) =>
      emit(ArticleStateTransformers.updateTitle(state, title));

  void onContentChanged(String content) =>
      emit(ArticleStateTransformers.updateContent(state, content));

  void onCoverImageUrlChanged(String url) =>
      emit(ArticleStateTransformers.updateCoverImageUrl(state, url));

  Future<String?> uploadCoverImage({
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (state.isUploadingCoverImage) return null;

    final user = _currentUser;
    if (user?.id == null) {
      emit(ArticleStateTransformers.authError(state));
      return null;
    }

    final dimError = await ArticleValidator.validateCoverImageBytesDimensions(
      bytes,
      bytesDimensionResolver: bytesDimensionResolver,
    );
    if (dimError != null) {
      emit(
        state.copyWith(
          formErrors: state.formErrors.copyWith(coverImageUrlError: dimError),
        ),
      );
      return null;
    }

    if (uploadArticleCoverImageUseCase == null) {
      emit(state.copyWith(errorMessage: 'Image upload service unavailable'));
      return null;
    }

    emit(
      state.copyWith(
        isUploadingCoverImage: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result = await uploadArticleCoverImageUseCase!(
      userId: user!.id!,
      bytes: bytes,
      fileExtension: fileName,
      previousCoverUrl: state.coverImageUrl,
    );

    return result.when(
      success: (publicUrl) {
        emit(
          ArticleStateTransformers.updateCoverImageUrl(
            state.copyWith(isUploadingCoverImage: false),
            publicUrl,
          ),
        );
        return publicUrl;
      },
      failure: (f) {
        emit(
          state.copyWith(isUploadingCoverImage: false, errorMessage: f.message),
        );
        return null;
      },
    );
  }

  void onCategorySelected(String? categoryId) =>
      emit(ArticleStateTransformers.selectCategory(state, categoryId));

  void onTagToggled(String tagName) =>
      emit(ArticleStateTransformers.toggleTag(state, tagName));

  void addCustomTag(String rawTag) =>
      emit(ArticleStateTransformers.applyCustomTag(state, rawTag));

  Future<void> saveDraft() async {
    if (state.isSavingDraft || state.isPublishing) return;
    final user = _currentUser;
    if (user?.id == null) {
      emit(ArticleStateTransformers.authError(state));
      return;
    }
    final titleErr = ArticleValidator.validateDraftTitle(state.title);
    if (titleErr != null) {
      emit(ArticleStateTransformers.draftTitleError(state, titleErr));
      return;
    }

    emit(
      state.copyWith(isSavingDraft: true, clearError: true, clearSuccess: true),
    );
    final isExisting =
        state.editingItemId != null && state.editingItemId!.isNotEmpty;
    final payload = ArticlePayloadBuilder.buildDraftPayload(
      state: state,
      user: user!,
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
      success: (article) =>
          emit(ArticleStateTransformers.buildDraftSuccessState(state, article)),
      failure: (f) =>
          emit(state.copyWith(isSavingDraft: false, errorMessage: f.message)),
    );
  }

  Future<void> publish() async {
    if (state.isSavingDraft || state.isPublishing) return;
    final user = _currentUser;
    if (user?.id == null) {
      emit(ArticleStateTransformers.authError(state));
      return;
    }

    final errors = await ArticlePayloadBuilder.validateStateForPublish(
      state: state,
      dimensionResolver: dimensionResolver,
    );
    if (errors.hasErrors) {
      emit(ArticleStateTransformers.publishErrors(state, errors));
      return;
    }

    emit(
      state.copyWith(isPublishing: true, clearError: true, clearSuccess: true),
    );
    final isNew = state.editingItemId == null || state.editingItemId!.isEmpty;
    final payload = ArticlePayloadBuilder.buildPublishPayload(
      state: state,
      user: user!,
      includeSlug: isNew,
    );

    if (state.editingItemStatus == 'published') {
      final res = await updateArticleUseCase.call(
        articleId: state.editingItemId!,
        updates: payload,
        status: 'published',
        publishedAt: state.publishedAt,
      );
      _handlePublishResult(res, 'Article updated successfully');
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

    _handlePublishResult(publishResult, 'Article published successfully');
  }

  void _handlePublishResult(
    ApiResult<ArticleEntity> result,
    String successMsg,
  ) {
    result.when(
      success: (article) => emit(
        ArticleStateTransformers.buildPublishSuccessState(
          state,
          article,
          successMsg,
        ),
      ),
      failure: (f) =>
          emit(state.copyWith(isPublishing: false, errorMessage: f.message)),
    );
  }
}
