import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/features/search/presentation/controllers/search_cubit.dart';

class SearchFilterHelper {
  const SearchFilterHelper._();

  static List<EditorialNewsItem> filterByTags(
    List<EditorialNewsItem> items,
    List<String> selectedTags,
  ) {
    if (selectedTags.isEmpty) return items;
    return items.where((item) {
      return selectedTags.every((st) =>
          item.tags.any((t) => t.toLowerCase() == st.toLowerCase()));
    }).toList();
  }

  static String mapFailureMessage(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('offline') ||
        lower.contains('network') ||
        lower.contains('connection') ||
        lower.contains('socket')) {
      return 'You are currently offline. Please check your internet connection.';
    }
    return raw.isNotEmpty ? raw : 'Failed to search articles.';
  }

  static List<String> toggleTag(List<String> currentTags, String tag) {
    final next = List<String>.from(currentTags);
    if (next.contains(tag)) {
      next.remove(tag);
    } else {
      next.add(tag);
    }
    return next;
  }

  static SearchState copyStateWithFilters({
    required SearchState currentState,
    required List<CategoryEntity> categories,
    required List<TagEntity> tags,
    required CategoryEntity? selectedCategory,
    required List<String> selectedTags,
  }) {
    if (currentState is SearchLoaded) {
      return SearchLoaded(
        results: currentState.results,
        query: currentState.query,
        selectedCategory: selectedCategory,
        selectedTags: List.unmodifiable(selectedTags),
        categories: categories,
        tags: tags,
      );
    }
    if (currentState is SearchEmpty) {
      return SearchEmpty(
        query: currentState.query,
        selectedCategory: selectedCategory,
        selectedTags: List.unmodifiable(selectedTags),
        categories: categories,
        tags: tags,
      );
    }
    if (currentState is SearchError) {
      return SearchError(
        message: currentState.message,
        query: currentState.query,
        selectedCategory: selectedCategory,
        selectedTags: List.unmodifiable(selectedTags),
        categories: categories,
        tags: tags,
      );
    }
    return SearchInitial(
      categories: categories,
      tags: tags,
      selectedCategory: selectedCategory,
      selectedTags: List.unmodifiable(selectedTags),
    );
  }
}
