import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_mock_data.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/design/editorial_saved_stack.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';

class ArticlesSaved extends StatefulWidget {
  const ArticlesSaved({super.key});
  static const String routeName = 'articlesSaved';

  @override
  State<ArticlesSaved> createState() => _ArticlesSavedState();
}

class _ArticlesSavedState extends State<ArticlesSaved> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late final List<EditorialNewsItem> _savedStories;

  @override
  void initState() {
    super.initState();
    _savedStories = List.from(EditorialMockData.savedStories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EditorialNewsItem> get _filteredStories {
    if (_searchQuery.trim().isEmpty) return _savedStories;
    final query = _searchQuery.toLowerCase();
    return _savedStories
        .where(
          (item) =>
              item.title.toLowerCase().contains(query) ||
              item.excerpt.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: EditorialPalette.ink,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
            children: [
              Row(
                children: [
                  EditorialIconButton(
                    icon: Icons.arrow_back_rounded,
                    label: 'Back',
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Saved News',
                    style: TextStyle(
                      color: EditorialPalette.softCream,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                ],
              ),
              CustomSearchBar(
                controller: _searchController,
                semanticLabel: 'Search saved news',
                hintText: 'Search news',
                trailingSearchIcon: true,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              EditorialSavedStack(
                items: _filteredStories,
                onOpenArticle: (item) => Navigator.pushNamed(context, AppRoutes.article, arguments: item),
                onDeleteArticle: (item) {
                  setState(() {
                    _savedStories.removeWhere((el) => el.id == item.id);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
