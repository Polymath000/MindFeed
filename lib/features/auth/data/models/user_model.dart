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
      email: json['email'],
      userName: json['userName'] ?? '',
      favoriteCategories: json['favoriteCategories'] ?? [],
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'favoriteCategories': favoriteCategories,
      'token': token,
    };
  }
}
