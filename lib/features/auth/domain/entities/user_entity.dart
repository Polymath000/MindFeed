import 'package:hive_flutter/adapters.dart';
part 'user_entity.g.dart';
@HiveType(typeId: 0)
class UserEntity {
  @HiveField(0)
  final String? userName;
  @HiveField(1)
  final String? email;
  @HiveField(2)
  final List<String>? favoriteCategories;
  @HiveField(3)
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
