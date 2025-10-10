import 'package:flutter/material.dart';
import 'package:mind_feed/features/collections/presentation/widgets/list_card.dart';

class ListForSavedArticles extends StatelessWidget {
  const ListForSavedArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            ListCard(isleft: true),
            ListCard(isleft: false),
            ListCard(isleft: true),
            ListCard(isleft: false),
          ],
        ),
      ),
    );
  }
}
