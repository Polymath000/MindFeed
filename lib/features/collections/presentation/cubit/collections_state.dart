part of 'collections_cubit.dart';

@immutable
sealed class CollectionsState {
  const CollectionsState();
}

final class CollectionsInitial extends CollectionsState {}
final class CollectionsLoading extends CollectionsState {}
final class CollectionsLoaded extends CollectionsState {
  final List<EditorialNewsItem> stories;
  const CollectionsLoaded(this.stories);
}
