import 'package:equatable/equatable.dart';
import 'package:mind_feed/features/add_article/domain/helpers/article_validator.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';

class AddArticleState extends Equatable {
  final bool isLoading;
  final bool isSavingDraft;
  final bool isPublishing;
  final bool isUploadingCoverImage;
  final bool isSuccess;
  final String? successMessage;
  final String? errorMessage;
  final List<CategoryEntity> categories;
  final List<TagEntity> availableTags;
  final String title;
  final String content;
  final String coverImageUrl;
  final String? selectedCategoryId;
  final List<String> selectedTags;
  final String? editingItemId;
  final String editingItemStatus;
  final DateTime? publishedAt;
  final ArticleFormErrors formErrors;
  final ArticleEntity? lastSavedArticle;

  const AddArticleState({
    this.isLoading = false,
    this.isSavingDraft = false,
    this.isPublishing = false,
    this.isUploadingCoverImage = false,
    this.isSuccess = false,
    this.successMessage,
    this.errorMessage,
    this.categories = const [],
    this.availableTags = const [],
    this.title = '',
    this.content = '',
    this.coverImageUrl = '',
    this.selectedCategoryId,
    this.selectedTags = const [],
    this.editingItemId,
    this.editingItemStatus = 'draft',
    this.publishedAt,
    this.formErrors = const ArticleFormErrors(),
    this.lastSavedArticle,
  });

  bool get isEditingPublished => editingItemStatus == 'published';
  int get titleWordCount => ArticleValidator.countWords(title);
  int get contentWordCount => ArticleValidator.countWords(content);
  bool get hasLockoutError =>
      isEditingPublished &&
      errorMessage != null &&
      errorMessage!.contains('30 days');
  bool get isReadOnly => hasLockoutError;

  AddArticleState copyWith({
    bool? isLoading,
    bool? isSavingDraft,
    bool? isPublishing,
    bool? isUploadingCoverImage,
    bool? isSuccess,
    String? successMessage,
    String? errorMessage,
    bool clearError = false,
    bool clearSuccess = false,
    List<CategoryEntity>? categories,
    List<TagEntity>? availableTags,
    String? title,
    String? content,
    String? coverImageUrl,
    String? selectedCategoryId,
    bool clearSelectedCategoryId = false,
    List<String>? selectedTags,
    String? editingItemId,
    String? editingItemStatus,
    DateTime? publishedAt,
    ArticleFormErrors? formErrors,
    ArticleEntity? lastSavedArticle,
  }) {
    return AddArticleState(
      isLoading: isLoading ?? this.isLoading,
      isSavingDraft: isSavingDraft ?? this.isSavingDraft,
      isPublishing: isPublishing ?? this.isPublishing,
      isUploadingCoverImage:
          isUploadingCoverImage ?? this.isUploadingCoverImage,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      categories: categories ?? this.categories,
      availableTags: availableTags ?? this.availableTags,
      title: title ?? this.title,
      content: content ?? this.content,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      selectedTags: selectedTags ?? this.selectedTags,
      editingItemId: editingItemId ?? this.editingItemId,
      editingItemStatus: editingItemStatus ?? this.editingItemStatus,
      publishedAt: publishedAt ?? this.publishedAt,
      formErrors: formErrors ?? this.formErrors,
      lastSavedArticle: lastSavedArticle ?? this.lastSavedArticle,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSavingDraft,
    isPublishing,
    isUploadingCoverImage,
    isSuccess,
    successMessage,
    errorMessage,
    categories,
    availableTags,
    title,
    content,
    coverImageUrl,
    selectedCategoryId,
    selectedTags,
    editingItemId,
    editingItemStatus,
    publishedAt,
    formErrors,
    lastSavedArticle,
  ];
}
