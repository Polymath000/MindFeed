import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

sealed class ProfileArticlesState extends Equatable {
  const ProfileArticlesState();

  @override
  List<Object?> get props => [];
}

final class ProfileArticlesInitial extends ProfileArticlesState {
  const ProfileArticlesInitial();
}

final class ProfileArticlesLoading extends ProfileArticlesState {
  const ProfileArticlesLoading();
}

final class ProfileArticlesLoaded extends ProfileArticlesState {
  final List<EditorialNewsItem> articles;

  const ProfileArticlesLoaded(this.articles);

  int get publishedCount =>
      articles.where((item) => item.status == 'published').length;

  int get draftCount =>
      articles.where((item) => item.status == 'draft').length;

  @override
  List<Object?> get props => [articles];
}

final class ProfileArticlesEmpty extends ProfileArticlesState {
  const ProfileArticlesEmpty();
}

final class ProfileArticlesError extends ProfileArticlesState {
  final String message;

  const ProfileArticlesError(this.message);

  @override
  List<Object?> get props => [message];
}
