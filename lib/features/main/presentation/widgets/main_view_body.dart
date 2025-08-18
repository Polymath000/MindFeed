import 'package:flutter/material.dart';
import 'package:mind_feed/features/aricles_by_categories/presentation/views/aricles_by_categories_view.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/search/presentation/views/search_view.dart';

class MainViewBody extends StatelessWidget {
  const MainViewBody({super.key, required this.selectesIndex});
  final int selectesIndex;
  @override
  Widget build(_) =>
      [HomeView(), SearchView(), AriclesByCategoriesView()][selectesIndex];
}
