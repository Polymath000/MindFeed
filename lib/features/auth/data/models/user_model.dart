import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userName,
    required super.email,
    required super.favoriteCategories,
    required super.token,
    super.avatarUrl,
  });

  factory UserModel.fromEntity(final UserEntity userEntity) => UserModel(
    favoriteCategories: userEntity.favoriteCategories,
    email: userEntity.email,
    userName: userEntity.userName,
    token: userEntity.token,
    avatarUrl: userEntity.avatarUrl,
  );

  UserEntity toUserEntity() => UserEntity(
    favoriteCategories: favoriteCategories,
    email: email,
    userName: userName,
    token: token,
    avatarUrl: avatarUrl,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      userName: json['userName'] ?? '',
      favoriteCategories: json['favoriteCategories'] ?? [],
      token: json['token'] ?? '',
      avatarUrl: (json['avatar_url'] ?? json['avatarUrl']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'favoriteCategories': favoriteCategories,
      'token': token,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }
}
