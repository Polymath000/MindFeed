class UserEntity {
  final String? userName;
  final String? email;
  final List<String>? favoriteCategories;
  final String? token;
  const UserEntity({
    required this.favoriteCategories,
    required this.email,
    required this.userName,
    required this.token,
  });

  UserEntity copyWith({
    final String? name,
    final String? email,
    final List<String>? categories,
    final String? token,
  }) => UserEntity(
    favoriteCategories: categories ?? favoriteCategories,
    email: email ?? this.email,
    userName: name ?? userName,
    token: token ?? this.token,
  );
}
