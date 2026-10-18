import 'package:equatable/equatable.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

sealed class AuthorState extends Equatable {
  const AuthorState();

  @override
  List<Object?> get props => [];
}

final class AuthorInitial extends AuthorState {
  const AuthorInitial();
}

final class AuthorLoading extends AuthorState {
  const AuthorLoading();
}

final class AuthorLoaded extends AuthorState {
  final List<EditorialNewsItem> articles;

  const AuthorLoaded(this.articles);

  @override
  List<Object?> get props => [articles];
}

final class AuthorEmpty extends AuthorState {
  const AuthorEmpty();
}

final class AuthorError extends AuthorState {
  final String message;

  const AuthorError(this.message);

  @override
  List<Object?> get props => [message];
}
