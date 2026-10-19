import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_state.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';

class AuthorCubit extends Cubit<AuthorState> {
  final GetHomeFeedUseCase _getHomeFeedUseCase;
  final GetArticlesByAuthorUseCase? _getArticlesByAuthorUseCase;

  AuthorCubit({
    required GetHomeFeedUseCase getHomeFeedUseCase,
    GetArticlesByAuthorUseCase? getArticlesByAuthorUseCase,
  })  : _getHomeFeedUseCase = getHomeFeedUseCase,
        _getArticlesByAuthorUseCase = getArticlesByAuthorUseCase,
        super(const AuthorInitial());

  Future<void> loadAuthorArticles(
    String authorName, {
    String? authorId,
  }) async {
    if (!isClosed) emit(const AuthorLoading());

    try {
      if (authorId != null &&
          authorId.trim().isNotEmpty &&
          _getArticlesByAuthorUseCase != null) {
        final result = await _getArticlesByAuthorUseCase(authorId.trim());
        if (isClosed) return;
        result.when(
          success: (articles) {
            final authorItems =
                articles.map((a) => a.toEditorialNewsItem()).toList();
            if (!isClosed) {
              if (authorItems.isEmpty) {
                emit(const AuthorEmpty());
              } else {
                emit(AuthorLoaded(List.unmodifiable(authorItems)));
              }
            }
          },
          failure: (failure) {
            if (!isClosed) emit(AuthorError(failure.message));
          },
        );
        return;
      }

      final result = await _getHomeFeedUseCase();
      if (isClosed) return;
      result.when(
        success: (articles) {
          final authorItems = articles
              .where((a) => a.authorName == authorName)
              .map((a) => a.toEditorialNewsItem())
              .toList();
          if (!isClosed) {
            if (authorItems.isEmpty) {
              emit(const AuthorEmpty());
            } else {
              emit(AuthorLoaded(List.unmodifiable(authorItems)));
            }
          }
        },
        failure: (failure) {
          if (!isClosed) emit(AuthorError(failure.message));
        },
      );
    } catch (e) {
      if (!isClosed) emit(AuthorError(e.toString()));
    }
  }
}
