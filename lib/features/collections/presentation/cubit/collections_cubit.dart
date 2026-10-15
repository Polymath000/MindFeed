import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/core/design/editorial_mock_data.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/usecases/get_saved_articles_use_case.dart';
import 'package:mind_feed/features/home/domain/usecases/toggle_bookmark_use_case.dart';
part 'collections_state.dart';

class CollectionsCubit extends Cubit<CollectionsState> {
  CollectionsCubit() : super(CollectionsInitial());

  List<EditorialNewsItem> _allStories = [];

  Future<void> loadSavedStories() async {
    emit(CollectionsLoading());
    if (getIt.isRegistered<GetSavedArticlesUseCase>()) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final result =
            await getIt<GetSavedArticlesUseCase>().call(user.id);
        result.when(
          success: (articles) {
            _allStories = articles.map((a) => a.toEditorialNewsItem()).toList();
            emit(CollectionsLoaded(_allStories));
          },
          failure: (_) {
            _allStories = List.from(EditorialMockData.savedStories);
            emit(CollectionsLoaded(_allStories));
          },
        );
        return;
      }
    }
    _allStories = List.from(EditorialMockData.savedStories);
    emit(CollectionsLoaded(_allStories));
  }

  void searchStories(String query) {
    if (query.trim().isEmpty) {
      emit(CollectionsLoaded(_allStories));
    } else {
      final filtered = _allStories
          .where((item) =>
              item.title.toLowerCase().contains(query.toLowerCase()) ||
              item.excerpt.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(CollectionsLoaded(filtered));
    }
  }

  Future<void> deleteArticle(String id) async {
    if (getIt.isRegistered<ToggleBookmarkUseCase>()) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await getIt<ToggleBookmarkUseCase>().call(
          articleId: id,
          userId: user.id,
          isCurrentlySaved: true,
        );
      }
    }
    _allStories.removeWhere((item) => item.id == id);
    if (state is CollectionsLoaded) {
      emit(CollectionsLoaded(List.from(_allStories)));
    }
  }
}
