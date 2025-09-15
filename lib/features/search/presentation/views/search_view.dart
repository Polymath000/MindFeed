import 'package:flutter/material.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';
import 'package:mind_feed/features/search/presentation/widgets/aricles_by_categories.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});
  static const String routeName = 'search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: [CustomSearchBar(), AriclesByCategories()]),
        ),
      ),
    );
  }
}
