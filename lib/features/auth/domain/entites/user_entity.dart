class UserEntity {
  final String? userName;
  final String? email;
  final String? password;
  final List<String>? favoriteCategories;

  const UserEntity({
    required this.favoriteCategories,
    required this.email,
    required this.password,
    required this.userName,
  });

  UserEntity copyWith({
    final String? username,
    final String? email,
    final String? password,
    final List<String>? categories,
  }) => UserEntity(
    favoriteCategories: categories ?? this.favoriteCategories,
    email: email ?? this.email,
    password: password ?? this.password,
    userName: userName ?? this.userName,
  );
}
