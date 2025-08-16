import 'package:mind_feed/features/auth/domain/entites/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userName,
    required super.email,
    required super.favoriteCategories,
    required super.password,
  });

  factory UserModel.fromEntity(final UserEntity userEntity) => UserModel(
    favoriteCategories: userEntity.favoriteCategories,
    email: userEntity.email,
    password: userEntity.password,
    userName: userEntity.userName,
  );

  UserEntity toUserEntity() => UserEntity(
    favoriteCategories: favoriteCategories,
    email: email,
    password: password,
    userName: userName,
  );

  // TODO : Handle the fromJson and toJson when the API is ready
}
