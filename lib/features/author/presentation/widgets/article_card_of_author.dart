import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class ArticleCardOfAuthor extends StatelessWidget {
  const ArticleCardOfAuthor({
    super.key,
    required this.title,
    required this.imagePath,
    this.isDwonload = false,
    this.isFav = false,
  });

  final String title;
  final String imagePath;
  final bool isDwonload;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppRoutes.article(context),
      borderRadius: EditorialRadii.card,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF262422),
          borderRadius: EditorialRadii.card,
          border: Border.all(color: const Color(0xFF383530)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 90,
                  height: 90,
                  color: EditorialPalette.cream,
                  child: const Icon(Icons.article_outlined, color: EditorialPalette.ink),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: EditorialPalette.softCream,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.bookmark : Icons.bookmark_border_rounded,
                          size: 18,
                          color: EditorialPalette.softCream,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.ios_share_rounded,
                          size: 18,
                          color: EditorialPalette.softCream,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
