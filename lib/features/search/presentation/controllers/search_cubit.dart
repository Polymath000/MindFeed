import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_tag_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/search/domain/usecases/get_articles_by_category_use_case.dart';
import 'package:mind_feed/features/search/domain/usecases/search_articles_use_case.dart';

import '../helpers/search_filter_helper.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchArticlesUseCase searchArticlesUseCase;
  final GetArticlesByCategoryUseCase getArticlesByCategoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetFixedTagsUseCase getFixedTagsUseCase;
  final GetArticlesByTagUseCase? getArticlesByTagUseCase;

  List<CategoryEntity> _categories = [];
  List<TagEntity> _tags = [];
  List<EditorialNewsItem> _unfilteredResults = [];
  String _currentQuery = '';
  CategoryEntity? _selectedCategory;
  final List<String> _selectedTags = [];
  Timer? _debounceTimer;
  int _activeRequestId = 0;

  SearchCubit({
    required this.searchArticlesUseCase,
    required this.getArticlesByCategoryUseCase,
    required this.getCategoriesUseCase,
    required this.getFixedTagsUseCase,
    this.getArticlesByTagUseCase,
  }) : super(const SearchInitial()) {
    loadInitialFilters();
  }

  List<CategoryEntity> get categories => List.unmodifiable(_categories);
  List<TagEntity> get tags => List.unmodifiable(_tags);
  String get currentQuery => _currentQuery;
  CategoryEntity? get selectedCategory => _selectedCategory;
  List<String> get selectedTags => List.unmodifiable(_selectedTags);

  void _safeEmit(SearchState nextState) {
    if (!isClosed) emit(nextState);
  }

  Future<void> loadInitialFilters() async {
    final catResult = await getCategoriesUseCase.call();
    catResult.when(
      success: (c) => _categories = c.take(20).toList(),
      failure: (_) {},
    );

    final tagResult = await getFixedTagsUseCase.call();
    tagResult.when(success: (t) => _tags = t, failure: (_) {});

    _emitWithCurrentFilters();
  }

  void _emitWithCurrentFilters() {
    _safeEmit(
      SearchFilterHelper.copyStateWithFilters(
        currentState: state,
        categories: _categories,
        tags: _tags,
        selectedCategory: _selectedCategory,
        selectedTags: _selectedTags,
      ),
    );
  }

  void onQueryChanged(String query) {
    _debounceTimer?.cancel();
    _currentQuery = query;
    if (query.trim().isEmpty) {
      _handleEmptyQueryFallback();
      return;
    }
    _debounceTimer = Timer(
      const Duration(milliseconds: 350),
      () => _performSearch(query.trim()),
    );
  }

  void _handleEmptyQueryFallback() {
    if (_selectedCategory != null) {
      final cat = _selectedCategory;
      _selectedCategory = null;
      selectCategory(cat);
    } else if (_selectedTags.isNotEmpty && getArticlesByTagUseCase != null) {
      _fetchByPrimaryTag();
    } else {
      _resetToInitialState();
    }
  }

  void _resetToInitialState() {
    _unfilteredResults = [];
    _activeRequestId++;
    _safeEmit(
      SearchInitial(
        categories: _categories,
        tags: _tags,
        selectedCategory: _selectedCategory,
        selectedTags: List<String>.unmodifiable(_selectedTags),
      ),
    );
  }

  void _emitLoading() => _safeEmit(
    SearchLoading(
      categories: _categories,
      tags: _tags,
      selectedCategory: _selectedCategory,
      selectedTags: List<String>.unmodifiable(_selectedTags),
    ),
  );

  void _emitError(String message) => _safeEmit(
    SearchError(
      message: message,
      query: _currentQuery,
      selectedCategory: _selectedCategory,
      selectedTags: List<String>.unmodifiable(_selectedTags),
      categories: _categories,
      tags: _tags,
    ),
  );

  Future<void> _fetchArticles(
    Future<ApiResult<List<ArticleEntity>>> Function() useCaseCall,
  ) async {
    _emitLoading();
    final requestId = ++_activeRequestId;
    final result = await useCaseCall();
    if (requestId != _activeRequestId || isClosed) return;
    result.when(
      success: (articles) {
        _unfilteredResults = articles
            .map((a) => a.toEditorialNewsItem())
            .toList();
        _applyFiltersAndEmit();
      },
      failure: (failure) =>
          _emitError(SearchFilterHelper.mapFailureMessage(failure.message)),
    );
  }

  Future<void> _performSearch(String query) {
    return _fetchArticles(() => searchArticlesUseCase.call(query));
  }

  Future<void> _fetchByPrimaryTag() {
    final primaryTag = _selectedTags.first;
    return _fetchArticles(() => getArticlesByTagUseCase!.call(primaryTag));
  }

  Future<void> selectCategory(CategoryEntity? category) async {
    _debounceTimer?.cancel();
    if (_selectedCategory == category || category == null) {
      _selectedCategory = null;
      await _reloadWithoutCategory();
      return;
    }

    _selectedCategory = category;
    await _fetchArticles(() => getArticlesByCategoryUseCase.call(category.id));
  }

  Future<void> _reloadWithoutCategory() async {
    if (_currentQuery.trim().isNotEmpty) {
      await _performSearch(_currentQuery.trim());
    } else if (_selectedTags.isNotEmpty && getArticlesByTagUseCase != null) {
      await _fetchByPrimaryTag();
    } else {
      _resetToInitialState();
    }
  }

  Future<void> applyFilters({
    required CategoryEntity? category,
    required List<String> tags,
  }) async {
    _debounceTimer?.cancel();
    final previousCategory = _selectedCategory;
    _selectedCategory = category;
    _selectedTags
      ..clear()
      ..addAll(tags);

    if (category != null) {
      if (previousCategory?.id != category.id || _unfilteredResults.isEmpty) {
        await _fetchArticles(
          () => getArticlesByCategoryUseCase.call(category.id),
        );
      } else {
        _applyFiltersAndEmit();
      }
      return;
    }

    if (_currentQuery.trim().isNotEmpty) {
      if (previousCategory != null || _unfilteredResults.isEmpty) {
        await _performSearch(_currentQuery.trim());
      } else {
        _applyFiltersAndEmit();
      }
      return;
    }

    if (_selectedTags.isNotEmpty && getArticlesByTagUseCase != null) {
      await _fetchByPrimaryTag();
      return;
    }

    _resetToInitialState();
  }

  Future<void> clearFilters() => applyFilters(category: null, tags: const []);

  void toggleTag(String tag) {
    final updated = SearchFilterHelper.toggleTag(_selectedTags, tag);
    _selectedTags
      ..clear()
      ..addAll(updated);

    if (_currentQuery.trim().isEmpty && _selectedCategory == null) {
      if (_selectedTags.isEmpty) {
        _resetToInitialState();
        return;
      }
      if (getArticlesByTagUseCase != null) {
        _fetchByPrimaryTag();
        return;
      }
    }
    _applyFiltersAndEmit();
  }

  void _applyFiltersAndEmit() {
    final filtered = SearchFilterHelper.filterByTags(
      _unfilteredResults,
      _selectedTags,
    );
    final tags = List<String>.unmodifiable(_selectedTags);
    _safeEmit(
      filtered.isEmpty
          ? SearchEmpty(
              query: _currentQuery,
              selectedCategory: _selectedCategory,
              selectedTags: tags,
              categories: _categories,
              tags: _tags,
            )
          : SearchLoaded(
              results: filtered,
              query: _currentQuery,
              selectedCategory: _selectedCategory,
              selectedTags: tags,
              categories: _categories,
              tags: _tags,
            ),
    );
  }

  Future<void> retry() async {
    if (_currentQuery.trim().isNotEmpty) {
      await _performSearch(_currentQuery.trim());
    } else if (_selectedCategory != null) {
      final cat = _selectedCategory;
      _selectedCategory = null;
      await selectCategory(cat);
    } else if (_selectedTags.isNotEmpty && getArticlesByTagUseCase != null) {
      await _fetchByPrimaryTag();
    } else {
      await loadInitialFilters();
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
