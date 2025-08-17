class UserEntity {
  final String? userName;
  final String? email;
  final String? password;
  final List<String>? favoriteCategories;
  final String? token;
  const UserEntity({
    required this.favoriteCategories,
    required this.email,
    required this.password,
    required this.userName,
    required this.token,
  });

  UserEntity copyWith({
    final String? name,
    final String? email,
    final String? password,
    final List<String>? categories,
    final String? token,
  }) => UserEntity(
    favoriteCategories: categories ?? this.favoriteCategories,
    email: email ?? this.email,
    password: password ?? this.password,
    userName: name ?? this.userName,
    token: token ?? this.token,
  );
}
