import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/features/search/domain/usecases/get_articles_by_category_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_categories_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_fixed_tags_use_case.dart';
import 'package:mind_feed/features/search/domain/usecases/search_articles_use_case.dart';
import 'package:mind_feed/features/search/presentation/helpers/search_filter_helper.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchArticlesUseCase searchArticlesUseCase;
  final GetArticlesByCategoryUseCase getArticlesByCategoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetFixedTagsUseCase getFixedTagsUseCase;

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
  }) : super(const SearchInitial()) {
    loadInitialFilters();
  }

  List<CategoryEntity> get categories => List.unmodifiable(_categories);
  List<TagEntity> get tags => List.unmodifiable(_tags);
  String get currentQuery => _currentQuery;
  CategoryEntity? get selectedCategory => _selectedCategory;
  List<String> get selectedTags => List.unmodifiable(_selectedTags);

  Future<void> loadInitialFilters() async {
    final catResult = await getCategoriesUseCase.call();
    catResult.when(
      success: (c) => _categories = c.take(20).toList(),
      failure: (_) {},
    );

    final tagResult = await getFixedTagsUseCase.call();
    tagResult.when(
      success: (t) => _tags = t,
      failure: (_) {},
    );

    _emitWithCurrentFilters();
  }

  void _emitWithCurrentFilters() {
    emit(SearchFilterHelper.copyStateWithFilters(
      currentState: state,
      categories: _categories,
      tags: _tags,
      selectedCategory: _selectedCategory,
      selectedTags: _selectedTags,
    ));
  }

  void onQueryChanged(String query) {
    _debounceTimer?.cancel();
    _currentQuery = query;
    if (query.trim().isEmpty) {
      _selectedCategory != null
          ? selectCategory(_selectedCategory)
          : _resetToInitialState();
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 350),
        () => _performSearch(query.trim()));
  }

  void _resetToInitialState() {
    _unfilteredResults = [];
    _activeRequestId++;
    emit(SearchInitial(
      categories: _categories,
      tags: _tags,
      selectedCategory: _selectedCategory,
      selectedTags: List<String>.unmodifiable(_selectedTags),
    ));
  }

  void _emitLoading() => emit(SearchLoading(
        categories: _categories,
        tags: _tags,
        selectedCategory: _selectedCategory,
        selectedTags: List<String>.unmodifiable(_selectedTags),
      ));

  void _emitError(String message) => emit(SearchError(
        message: message,
        query: _currentQuery,
        selectedCategory: _selectedCategory,
        selectedTags: List<String>.unmodifiable(_selectedTags),
        categories: _categories,
        tags: _tags,
      ));

  Future<void> _fetchArticles(
    Future<ApiResult<List<ArticleEntity>>> Function() useCaseCall,
    String unavailableMessage,
  ) async {
    _emitLoading();
    final requestId = ++_activeRequestId;
    final result = await useCaseCall();
    if (requestId != _activeRequestId) return;
    result.when(
      success: (articles) {
        _unfilteredResults =
            articles.map((a) => a.toEditorialNewsItem()).toList();
        _applyFiltersAndEmit();
      },
      failure: (failure) =>
          _emitError(SearchFilterHelper.mapFailureMessage(failure.message)),
    );
  }

  Future<void> _performSearch(String query) async {
    await _fetchArticles(
      () => searchArticlesUseCase.call(query),
      'Search service unavailable.',
    );
  }

  Future<void> selectCategory(CategoryEntity? category) async {
    _debounceTimer?.cancel();
    if (_selectedCategory == category || category == null) {
      _selectedCategory = null;
      _currentQuery.trim().isNotEmpty
          ? await _performSearch(_currentQuery.trim())
          : _resetToInitialState();
      return;
    }

    _selectedCategory = category;
    await _fetchArticles(
      () => getArticlesByCategoryUseCase.call(category.id),
      'Category service unavailable.',
    );
  }

  void toggleTag(String tag) {
    final updated = SearchFilterHelper.toggleTag(_selectedTags, tag);
    _selectedTags
      ..clear()
      ..addAll(updated);
    _applyFiltersAndEmit();
  }

  void _applyFiltersAndEmit() {
    final filtered =
        SearchFilterHelper.filterByTags(_unfilteredResults, _selectedTags);
    final tags = List<String>.unmodifiable(_selectedTags);
    emit(filtered.isEmpty
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
          ));
  }

  Future<void> retry() async {
    if (_currentQuery.trim().isNotEmpty) {
      await _performSearch(_currentQuery.trim());
    } else if (_selectedCategory != null) {
      final cat = _selectedCategory;
      _selectedCategory = null;
      await selectCategory(cat);
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
