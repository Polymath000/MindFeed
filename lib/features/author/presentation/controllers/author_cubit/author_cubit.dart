import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/author/presentation/controllers/author_cubit/author_state.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';

class AuthorCubit extends Cubit<AuthorState> {
  final GetHomeFeedUseCase _getHomeFeedUseCase;

  AuthorCubit({
    required GetHomeFeedUseCase getHomeFeedUseCase,
  })  : _getHomeFeedUseCase = getHomeFeedUseCase,
        super(const AuthorInitial());

  Future<void> loadAuthorArticles(String authorName) async {
    if (!isClosed) emit(const AuthorLoading());

    try {
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
