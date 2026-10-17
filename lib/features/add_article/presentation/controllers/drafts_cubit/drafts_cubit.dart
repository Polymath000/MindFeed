import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/drafts_cubit/drafts_state.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/delete_article_use_case.dart';

class DraftsCubit extends Cubit<DraftsState> {
  final ArticlesRepository articlesRepository;
  final DeleteArticleUseCase deleteArticleUseCase;
  final CurrentUserSnapshot? Function()? userResolver;

  DraftsCubit({
    ArticlesRepository? articlesRepository,
    DeleteArticleUseCase? deleteArticleUseCase,
    this.userResolver,
  })  : articlesRepository =
            articlesRepository ?? getIt<ArticlesRepository>(),
        deleteArticleUseCase =
            deleteArticleUseCase ?? getIt<DeleteArticleUseCase>(),
        super(const DraftsInitial());

  CurrentUserSnapshot? get _currentUser {
    if (userResolver != null) {
      return userResolver!();
    }
    return CurrentUserSession.resolveCurrentUser();
  }

  Future<void> loadDrafts() async {
    emit(const DraftsLoading());

    final user = _currentUser;
    if (user == null || user.id == null) {
      emit(const DraftsError('User not authenticated'));
      return;
    }

    final result = await articlesRepository.getArticlesByAuthor(user.id!);

    result.when(
      success: (articles) {
        final drafts = articles
            .where((article) => article.status == 'draft')
            .map((article) => article.toEditorialNewsItem())
            .toList();

        if (drafts.isEmpty) {
          emit(const DraftsEmpty());
        } else {
          emit(DraftsLoaded(drafts));
        }
      },
      failure: (failure) {
        emit(DraftsError(failure.message));
      },
    );
  }

  Future<void> deleteDraft(String articleId) async {
    final result = await deleteArticleUseCase.call(articleId);

    await result.when<Future<void>>(
      success: (_) async {
        await loadDrafts();
      },
      failure: (failure) async {
        emit(DraftsError(failure.message));
      },
    );
  }
}
