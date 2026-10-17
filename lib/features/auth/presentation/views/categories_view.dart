import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/presentation/controllers/categories_cubit/categories_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/categories_view_body.dart';
import 'package:mind_feed/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mind_feed/features/profile/data/repos/profile_repo_impl.dart';
import 'package:mind_feed/features/profile/domain/usecases/save_favorite_categories_use_case.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({
    super.key,
    this.userEntity,
    this.profileRemoteDataSource,
    this.categoriesCubit,
  });

  final UserEntity? userEntity;
  final ProfileRemoteDataSource? profileRemoteDataSource;
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
    return Scaffold(
      body: BlocProvider<CategoriesCubit>(
        create: (_) => _buildCubit(),
        child: CategoriesViewBody(userEntity: userEntity),
      ),
    );
  }

  CategoriesCubit _buildCubit() {
    final initial = userEntity?.favoriteCategories;

    if (profileRemoteDataSource != null) {
      final repo = ProfileRepoImpl(remoteDataSource: profileRemoteDataSource!);
      final useCase = SaveFavoriteCategoriesUseCase(repo);
      return CategoriesCubit(
        saveFavoriteCategoriesUseCase: useCase,
        initialCategories: initial,
      );
    }

    if (getIt.isRegistered<SaveFavoriteCategoriesUseCase>()) {
      return CategoriesCubit(
        saveFavoriteCategoriesUseCase: getIt<SaveFavoriteCategoriesUseCase>(),
        initialCategories: initial,
      );
    }

    final repo = ProfileRepoImpl(
      remoteDataSource: getIt.isRegistered<ProfileRemoteDataSource>()
          ? getIt<ProfileRemoteDataSource>()
          : ProfileRemoteDataSourceImpl(),
    );
    final useCase = SaveFavoriteCategoriesUseCase(repo);
    return CategoriesCubit(
      saveFavoriteCategoriesUseCase: useCase,
      initialCategories: initial,
    );
  }
}
