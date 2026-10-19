import 'package:equatable/equatable.dart';

class AuthorProfileArgs extends Equatable {
  final String authorName;
  final String? authorRole;
  final String? authorAvatar;
  final String? authorId;

  const AuthorProfileArgs({
    required this.authorName,
    this.authorRole,
    this.authorAvatar,
    this.authorId,
  });

  @override
  List<Object?> get props => [authorName, authorRole, authorAvatar, authorId];
}
