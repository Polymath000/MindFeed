import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/search/presentation/controllers/search_cubit.dart';

class ArticlesCategoryView extends StatelessWidget {
  final SearchCubit? cubit;

  const ArticlesCategoryView({super.key, this.cubit});
  static const String routeName = "articles_category_view";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit ?? getIt<SearchCubit>(),
      child: const Scaffold(body: Center(child: Text('Category stories'))),
    );
  }
}
