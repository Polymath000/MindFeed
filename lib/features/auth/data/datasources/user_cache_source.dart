import 'package:mind_feed/core/database/cache/cache_helper.dart';
import 'package:mind_feed/core/errors/expentions.dart';
import 'package:mind_feed/features/auth/data/models/user_model.dart';
import 'dart:convert';

class UserCacheDataSource {
  final CacheHelper cacheHelper;
  final String key = "user";
  UserCacheDataSource({required this.cacheHelper});

  cacheUser(UserModel? userToCache) {
    if (userToCache != null) {
      cacheHelper.saveData(key: key, value: json.encode(userToCache.toJson()));
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection");
    }
  }

  Future<UserModel> getUser() {
    final jsonString = cacheHelper.getDataString(key: key);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection");
    }
  }
}
