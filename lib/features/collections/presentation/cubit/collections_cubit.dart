import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_mock_data.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
part 'collections_state.dart';

class CollectionsCubit extends Cubit<CollectionsState> {
  CollectionsCubit() : super(CollectionsInitial());

  List<EditorialNewsItem> _allStories = [];

  void loadSavedStories() {
    emit(CollectionsLoading());
    // Simulate repository fetch
    _allStories = List.from(EditorialMockData.savedStories);
    emit(CollectionsLoaded(_allStories));
  }

  void searchStories(String query) {
    if (query.trim().isEmpty) {
      emit(CollectionsLoaded(_allStories));
    } else {
      final filtered = _allStories.where((item) =>
          item.title.toLowerCase().contains(query.toLowerCase()) ||
          item.excerpt.toLowerCase().contains(query.toLowerCase())).toList();
      emit(CollectionsLoaded(filtered));
    }
  }

  void deleteArticle(String id) {
    _allStories.removeWhere((item) => item.id == id);
    if (state is CollectionsLoaded) {
      emit(CollectionsLoaded(List.from(_allStories)));
    }
  }
}
