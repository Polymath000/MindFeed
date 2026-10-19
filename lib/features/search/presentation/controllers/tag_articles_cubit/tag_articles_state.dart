import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

sealed class TagArticlesState extends Equatable {
  const TagArticlesState();

  @override
  List<Object?> get props => [];
}

final class TagArticlesInitial extends TagArticlesState {
  const TagArticlesInitial();
}

final class TagArticlesLoading extends TagArticlesState {
  const TagArticlesLoading();
}

final class TagArticlesLoaded extends TagArticlesState {
  final List<EditorialNewsItem> articles;

  const TagArticlesLoaded(this.articles);

  @override
  List<Object?> get props => [articles];
}

final class TagArticlesEmpty extends TagArticlesState {
  const TagArticlesEmpty();
}

final class TagArticlesError extends TagArticlesState {
  final String message;

  const TagArticlesError(this.message);

  @override
  List<Object?> get props => [message];
}
