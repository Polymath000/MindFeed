import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/repos/articles_repo.dart';
import 'package:mind_feed/features/home/domain/usecases/delete_article_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_state.dart';

class ProfileArticlesCubit extends Cubit<ProfileArticlesState> {
  final ArticlesRepository? _articlesRepo;
  final DeleteArticleUseCase? _deleteArticleUseCase;
  final String? _configuredUserId;
  List<EditorialNewsItem> _articles = [];

  ProfileArticlesCubit({
    ArticlesRepository? articlesRepository,
    DeleteArticleUseCase? deleteArticleUseCase,
    String? userId,
  }) : _articlesRepo =
           articlesRepository ??
           (getIt.isRegistered<ArticlesRepository>()
               ? getIt<ArticlesRepository>()
               : null),
       _deleteArticleUseCase =
           deleteArticleUseCase ??
           (articlesRepository != null
               ? DeleteArticleUseCase(articlesRepository)
               : (getIt.isRegistered<DeleteArticleUseCase>()
                     ? getIt<DeleteArticleUseCase>()
                     : (getIt.isRegistered<ArticlesRepository>()
                           ? DeleteArticleUseCase(getIt<ArticlesRepository>())
                           : null))),
       _configuredUserId = userId,
       super(const ProfileArticlesInitial());

  List<EditorialNewsItem> get articles => List.unmodifiable(_articles);

  Future<void> loadArticles({String? userId}) async {
    String? targetUserId = userId ?? _configuredUserId;
    if (targetUserId == null || targetUserId.isEmpty) {
      targetUserId = CurrentUserSession.currentUserId;
    }

    final repo = _articlesRepo;
    if (repo == null || targetUserId == null || targetUserId.isEmpty) {
      _articles = [];
      emit(const ProfileArticlesEmpty());
      return;
    }

    emit(const ProfileArticlesLoading());

    try {
      final result = await repo.getArticlesByAuthor(targetUserId);
      result.when(
        success: (entities) {
          _articles = entities.map((e) => e.toEditorialNewsItem()).toList();
          if (_articles.isEmpty) {
            emit(const ProfileArticlesEmpty());
          } else {
            emit(ProfileArticlesLoaded(List.unmodifiable(_articles)));
          }
        },
        failure: (failure) {
          emit(ProfileArticlesError(failure.message));
        },
      );
    } catch (e) {
      emit(ProfileArticlesError(e.toString()));
    }
  }

  Future<bool> deleteArticle(String articleId) async {
    final useCase =
        _deleteArticleUseCase ??
        (_articlesRepo != null ? DeleteArticleUseCase(_articlesRepo) : null);

    if (useCase == null) {
      return false;
    }

    try {
      final result = await useCase.call(articleId);
      final success = result.when<bool>(
        success: (_) {
          _articles.removeWhere((item) => item.id == articleId);
          if (_articles.isEmpty) {
            emit(const ProfileArticlesEmpty());
          } else {
            emit(ProfileArticlesLoaded(List.unmodifiable(_articles)));
          }
          return true;
        },
        failure: (_) => false,
      );
      return success;
    } catch (_) {
      return false;
    }
  }
}
