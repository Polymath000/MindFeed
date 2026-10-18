part of 'collections_cubit.dart';

@immutable
sealed class CollectionsState extends Equatable {
  const CollectionsState();

  @override
  List<Object?> get props => [];
}

final class CollectionsInitial extends CollectionsState {}

final class CollectionsLoading extends CollectionsState {}

final class CollectionsLoaded extends CollectionsState {
  final List<EditorialNewsItem> stories;
  const CollectionsLoaded(this.stories);

  @override
  List<Object?> get props => [stories];
}

final class CollectionsEmpty extends CollectionsState {
  const CollectionsEmpty();
}

final class CollectionsError extends CollectionsState {
  final String message;
  const CollectionsError(this.message);

  @override
  List<Object?> get props => [message];
}
