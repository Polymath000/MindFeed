import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';

part 'collections_state.dart';

class CollectionsCubit extends Cubit<CollectionsState> {
  final GetSavedArticlesUseCase? _getSavedArticlesUseCase;
  final ToggleBookmarkUseCase? _toggleBookmarkUseCase;

  CollectionsCubit({
    GetSavedArticlesUseCase? getSavedArticlesUseCase,
    ToggleBookmarkUseCase? toggleBookmarkUseCase,
  })  : _getSavedArticlesUseCase = getSavedArticlesUseCase,
        _toggleBookmarkUseCase = toggleBookmarkUseCase,
        super(CollectionsInitial());

  List<EditorialNewsItem> _allStories = [];

  List<EditorialNewsItem> get allStories => List.unmodifiable(_allStories);

  Future<void> loadSavedStories() async {
    emit(CollectionsLoading());

    final userId = CurrentUserSession.currentUserId;
    if (userId == null) {
      emit(const CollectionsError(
          'Please log in to view your saved articles.'));
      return;
    }

    final useCase = _getSavedArticlesUseCase ??
        (getIt.isRegistered<GetSavedArticlesUseCase>()
            ? getIt<GetSavedArticlesUseCase>()
            : null);

    if (useCase == null) {
      emit(const CollectionsError('Saved articles service unavailable.'));
      return;
    }

    final result = await useCase.call(userId);
    result.when(
      success: (articles) {
        _allStories = articles.map((a) => a.toEditorialNewsItem()).toList();
        if (_allStories.isEmpty) {
          emit(const CollectionsEmpty());
        } else {
          emit(CollectionsLoaded(List.from(_allStories)));
        }
      },
      failure: (failure) {
        final msg = failure.message.toLowerCase();
        if (msg.contains('offline') ||
            msg.contains('network') ||
            msg.contains('connection') ||
            msg.contains('socket')) {
          emit(const CollectionsError(
              'You are currently offline. Please check your internet connection.'));
        } else {
          emit(CollectionsError(failure.message.isNotEmpty
              ? failure.message
              : 'Failed to load saved articles.'));
        }
      },
    );
  }

  void searchStories(String query) {
    if (query.trim().isEmpty) {
      if (_allStories.isEmpty) {
        emit(const CollectionsEmpty());
      } else {
        emit(CollectionsLoaded(List.from(_allStories)));
      }
    } else {
      final filtered = _allStories
          .where((item) =>
              item.title.toLowerCase().contains(query.toLowerCase()) ||
              item.excerpt.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (filtered.isEmpty) {
        emit(const CollectionsEmpty());
      } else {
        emit(CollectionsLoaded(filtered));
      }
    }
  }

  Future<void> deleteArticle(String id) async {
    final userId = CurrentUserSession.currentUserId;
    if (userId == null) {
      emit(const CollectionsError(
          'Please log in to manage saved articles.'));
      return;
    }

    final useCase = _toggleBookmarkUseCase ??
        (getIt.isRegistered<ToggleBookmarkUseCase>()
            ? getIt<ToggleBookmarkUseCase>()
            : null);

    if (useCase == null) {
      emit(const CollectionsError('Bookmark service is unavailable.'));
      return;
    }

    final result = await useCase.call(
      articleId: id,
      userId: userId,
      isCurrentlySaved: true,
    );

    result.when(
      success: (isSaved) {
        if (!isSaved) {
          _allStories.removeWhere((item) => item.id == id);
          if (_allStories.isEmpty) {
            emit(const CollectionsEmpty());
          } else {
            emit(CollectionsLoaded(List.from(_allStories)));
          }
        }
      },
      failure: (failure) {
        emit(CollectionsError(failure.message.isNotEmpty
            ? failure.message
            : 'Failed to remove saved article.'));
      },
    );
  }
}
