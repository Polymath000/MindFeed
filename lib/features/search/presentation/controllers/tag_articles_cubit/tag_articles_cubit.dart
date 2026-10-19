import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_tag_use_case.dart';
import 'package:mind_feed/features/search/presentation/controllers/tag_articles_cubit/tag_articles_state.dart';

class TagArticlesCubit extends Cubit<TagArticlesState> {
  final GetArticlesByTagUseCase _getArticlesByTagUseCase;

  TagArticlesCubit({
    required GetArticlesByTagUseCase getArticlesByTagUseCase,
  })  : _getArticlesByTagUseCase = getArticlesByTagUseCase,
        super(const TagArticlesInitial());

  Future<void> loadArticlesByTag(String tag) async {
    if (!isClosed) emit(const TagArticlesLoading());

    try {
      final result = await _getArticlesByTagUseCase(tag);
      if (isClosed) return;

      result.when(
        success: (articles) {
          final items = articles.map((a) => a.toEditorialNewsItem()).toList();
          if (!isClosed) {
            if (items.isEmpty) {
              emit(const TagArticlesEmpty());
            } else {
              emit(TagArticlesLoaded(List.unmodifiable(items)));
            }
          }
        },
        failure: (failure) {
          if (!isClosed) emit(TagArticlesError(failure.message));
        },
      );
    } catch (e) {
      if (!isClosed) emit(TagArticlesError(e.toString()));
    }
  }
}
