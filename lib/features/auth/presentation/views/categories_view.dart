import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/domain/entites/user_entity.dart';
import 'package:mind_feed/features/auth/presentation/widgets/categories_view_body.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key, required this.userEntity});
  final UserEntity userEntity;
  static const String routeName = 'categories';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CategoriesViewBody());
  }
}
