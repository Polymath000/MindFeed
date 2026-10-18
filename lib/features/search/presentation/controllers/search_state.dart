part of 'search_cubit.dart';

@immutable
sealed class SearchState extends Equatable {
  final List<CategoryEntity> categories;
  final List<TagEntity> tags;
  final CategoryEntity? selectedCategory;
  final List<String> selectedTags;

  const SearchState({
    this.categories = const [],
    this.tags = const [],
    this.selectedCategory,
    this.selectedTags = const [],
  });

  @override
  List<Object?> get props => [
        categories,
        tags,
        selectedCategory,
        selectedTags,
      ];
}

final class SearchInitial extends SearchState {
  const SearchInitial({
    super.categories,
    super.tags,
    super.selectedCategory,
    super.selectedTags,
  });
}

final class SearchLoading extends SearchState {
  const SearchLoading({
    super.categories,
    super.tags,
    super.selectedCategory,
    super.selectedTags,
  });
}

final class SearchLoaded extends SearchState {
  final List<EditorialNewsItem> results;
  final String query;

  const SearchLoaded({
    required this.results,
    this.query = '',
    super.selectedCategory,
    super.selectedTags,
    super.categories,
    super.tags,
  });

  @override
  List<Object?> get props => [
        results,
        query,
        selectedCategory,
        selectedTags,
        categories,
        tags,
      ];
}

final class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty({
    this.query = '',
    super.selectedCategory,
    super.selectedTags,
    super.categories,
    super.tags,
  });

  @override
  List<Object?> get props => [
        query,
        selectedCategory,
        selectedTags,
        categories,
        tags,
      ];
}

final class SearchError extends SearchState {
  final String message;
  final String query;

  const SearchError({
    required this.message,
    this.query = '',
    super.selectedCategory,
    super.selectedTags,
    super.categories,
    super.tags,
  });

  @override
  List<Object?> get props => [
        message,
        query,
        selectedCategory,
        selectedTags,
        categories,
        tags,
      ];
}