import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});
  static const String routeName = 'search';
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: EditorialPalette.ink,
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
                  color: EditorialPalette.softCream,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const CustomSearchBar(),
              const Text(
                'Browse topics',
                style: TextStyle(
                  color: EditorialPalette.softCream,
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
                              color: EditorialPalette.ink,
                              fontWeight: FontWeight.w700,
                            ),
                            backgroundColor: EditorialPalette.cream,
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
