import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});
  static const String routeName = 'search';
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.ink,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 132),
            children: [
              const Text(
                'Search',
                style: TextStyle(
                  color: AppColors.softCream,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const CustomSearchBar(),
              const Text(
                'Browse topics',
                style: TextStyle(
                  color: AppColors.softCream,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    ['Health', 'Sports', 'Finance', 'Technology', 'Culture']
                        .map(
                          (topic) => Chip(
                            label: Text(topic),
                            labelStyle: const TextStyle(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w700,
                            ),
                            backgroundColor: AppColors.cream,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
