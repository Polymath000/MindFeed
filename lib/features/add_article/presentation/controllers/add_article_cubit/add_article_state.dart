part of 'add_article_cubit.dart';

@immutable
sealed class AddArticleState {
  const AddArticleState();
}

final class AddArticleInitial extends AddArticleState {}
final class AddArticleLoading extends AddArticleState {}
final class AddArticleError extends AddArticleState {
  final String message;
  const AddArticleError(this.message);
}
final class AddArticleFileLoaded extends AddArticleState {
  final String content;
  final String fileName;
  const AddArticleFileLoaded(this.content, this.fileName);
}
