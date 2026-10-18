import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/profile/presentation/controllers/categories_cubit/categories_cubit.dart';
import 'package:mind_feed/features/profile/presentation/widgets/categories_view_body.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({
    super.key,
    this.userEntity,
    this.categoriesCubit,
  });

  final UserEntity? userEntity;
  final CategoriesCubit? categoriesCubit;
  static const String routeName = 'categories';

  @override
  Widget build(BuildContext context) {
    if (categoriesCubit != null) {
      return Scaffold(
        body: BlocProvider<CategoriesCubit>.value(
          value: categoriesCubit!,
          child: CategoriesViewBody(userEntity: userEntity),
        ),
      );
    }

    try {
      context.read<CategoriesCubit>();
      return Scaffold(
        body: CategoriesViewBody(userEntity: userEntity),
      );
    } catch (_) {
      return Scaffold(
        body: BlocProvider<CategoriesCubit>(
          create: (_) {
            final cubit = GetIt.instance<CategoriesCubit>();
            final initial = userEntity?.favoriteCategories;
            if (initial != null && initial.isNotEmpty) {
              cubit.initialize(initial);
            }
            return cubit;
          },
          child: CategoriesViewBody(userEntity: userEntity),
        ),
      );
    }
  }
}

