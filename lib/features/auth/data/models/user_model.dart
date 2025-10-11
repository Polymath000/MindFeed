import 'package:mind_feed/core/database/api/api_key.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userName,
    required super.email,
    required super.favoriteCategories,
    required super.token,
  });

  factory UserModel.fromEntity(final UserEntity userEntity) => UserModel(
    favoriteCategories: userEntity.favoriteCategories,
    email: userEntity.email,
    userName: userEntity.userName,
    token: userEntity.token,
  );

  UserEntity toUserEntity() => UserEntity(
    favoriteCategories: favoriteCategories,
    email: email,
    userName: userName,
    token: token,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json[ApiKey.email],
      userName: json[ApiKey.userName] ?? '',
      favoriteCategories: json[ApiKey.favoriteCategories] ?? [],
      token: json[ApiKey.token] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.userName: userName,
      ApiKey.email: email,
      ApiKey.favoriteCategories: favoriteCategories,
      ApiKey.token: token,
    };
  }
}
