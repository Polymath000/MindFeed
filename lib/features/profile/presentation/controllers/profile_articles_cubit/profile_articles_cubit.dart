import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/articles/domain/usecases/delete_article_use_case.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_articles_by_author_use_case.dart';
import 'package:mind_feed/features/profile/presentation/controllers/profile_articles_cubit/profile_articles_state.dart';

class ProfileArticlesCubit extends Cubit<ProfileArticlesState> {
  final GetArticlesByAuthorUseCase _getArticlesByAuthorUseCase;
  final DeleteArticleUseCase _deleteArticleUseCase;
  final String? _configuredUserId;
  List<EditorialNewsItem> _articles = [];

  ProfileArticlesCubit({
    required GetArticlesByAuthorUseCase getArticlesByAuthorUseCase,
    required DeleteArticleUseCase deleteArticleUseCase,
    String? userId,
  })  : _getArticlesByAuthorUseCase = getArticlesByAuthorUseCase,
        _deleteArticleUseCase = deleteArticleUseCase,
        _configuredUserId = userId,
        super(const ProfileArticlesInitial());

  List<EditorialNewsItem> get articles => List.unmodifiable(_articles);

  Future<void> loadArticles({String? userId}) async {
    String? targetUserId = userId ?? _configuredUserId;
    if (targetUserId == null || targetUserId.isEmpty) {
      targetUserId = CurrentUserSession.currentUserId;
    }

    if (targetUserId == null || targetUserId.isEmpty) {
      _articles = [];
      if (!isClosed) emit(const ProfileArticlesEmpty());
      return;
    }

    if (!isClosed) emit(const ProfileArticlesLoading());

    try {
      final result = await _getArticlesByAuthorUseCase(targetUserId);
      if (isClosed) return;
      result.when(
        success: (entities) {
          _articles = entities.map((e) => e.toEditorialNewsItem()).toList();
          if (!isClosed) {
            if (_articles.isEmpty) {
              emit(const ProfileArticlesEmpty());
            } else {
              emit(ProfileArticlesLoaded(List.unmodifiable(_articles)));
            }
          }
        },
        failure: (failure) {
          if (!isClosed) emit(ProfileArticlesError(failure.message));
        },
      );
    } catch (e) {
      if (!isClosed) emit(ProfileArticlesError(e.toString()));
    }
  }

  Future<bool> deleteArticle(String articleId) async {
    try {
      final result = await _deleteArticleUseCase(articleId);
      final success = result.when<bool>(
        success: (_) {
          _articles.removeWhere((item) => item.id == articleId);
          if (!isClosed) {
            if (_articles.isEmpty) {
              emit(const ProfileArticlesEmpty());
            } else {
              emit(ProfileArticlesLoaded(List.unmodifiable(_articles)));
            }
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
