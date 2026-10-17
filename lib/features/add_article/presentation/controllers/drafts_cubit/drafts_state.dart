import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

sealed class DraftsState extends Equatable {
  const DraftsState();

  @override
  List<Object?> get props => [];
}

final class DraftsInitial extends DraftsState {
  const DraftsInitial();
}

final class DraftsLoading extends DraftsState {
  const DraftsLoading();
}

final class DraftsEmpty extends DraftsState {
  const DraftsEmpty();
}

final class DraftsLoaded extends DraftsState {
  final List<EditorialNewsItem> drafts;

  const DraftsLoaded(this.drafts);

  @override
  List<Object?> get props => [drafts];
}

final class DraftsError extends DraftsState {
  final String message;

  const DraftsError(this.message);

  @override
  List<Object?> get props => [message];
}
