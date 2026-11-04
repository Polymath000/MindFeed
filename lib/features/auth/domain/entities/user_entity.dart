class UserEntity {
  final String? userName;
  final String? email;
  final List<String>? favoriteCategories;
  final String? token;
  final String? avatarUrl;

  const UserEntity({
    required this.favoriteCategories,
    required this.email,
    required this.userName,
    required this.token,
    this.avatarUrl,
  });

  UserEntity copyWith({
    final String? name,
    final String? email,
    final List<String>? categories,
    final String? token,
    final String? avatarUrl,
  }) => UserEntity(
    favoriteCategories: categories ?? favoriteCategories,
    email: email ?? this.email,
    userName: name ?? userName,
    token: token ?? this.token,
    avatarUrl: avatarUrl ?? this.avatarUrl,
  );
}
