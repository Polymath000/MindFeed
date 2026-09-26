import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_mock_data.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/utls/app_images.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key, this.item});
  static const String routeName = 'article';

  final EditorialNewsItem? item;

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late EditorialNewsItem _article;
  late bool _isLiked;
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _article = widget.item ?? EditorialMockData.stories.first;
    _isLiked = _article.isLiked;
    _isSaved = _article.isSaved;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _article.color,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Semantics(
                      button: true,
                      label: 'Back',
                      child: InkResponse(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: EditorialPalette.ink,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _article.badgeColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            _article.badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.volume_up_outlined,
                            color: EditorialPalette.ink,
                          ),
                          tooltip: 'Listen to article',
                          onPressed: () {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text('Voice synthesis activated: Reading story aloud'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _article.title.replaceAll('\n', ' '),
                  style: const TextStyle(
                    fontSize: 30,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    color: EditorialPalette.ink,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      _article.updated,
                      style: const TextStyle(
                        color: EditorialPalette.mutedInk,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('•', style: TextStyle(color: EditorialPalette.mutedInk)),
                    ),
                    const Text(
                      '6 min read',
                      style: TextStyle(
                        color: EditorialPalette.mutedInk,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        _article.authorAvatar,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const CircleAvatar(
                          radius: 20,
                          backgroundColor: EditorialPalette.blush,
                          child: Icon(Icons.person, color: EditorialPalette.ink),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _article.authorRole,
                            style: const TextStyle(
                              fontSize: 11,
                              color: EditorialPalette.mutedInk,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _article.authorName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: EditorialPalette.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    EditorialFollowButton(authorName: _article.authorName),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  _article.excerpt,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                    color: EditorialPalette.ink,
                  ),
                ),
                const SizedBox(height: 22),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        Assets.assetsImagesPills,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: Icon(Icons.image_outlined, size: 48, color: EditorialPalette.ink),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 14,
                      bottom: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: EditorialPalette.ink,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            EditorialIconButton(
                              icon: _isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              label: 'Like article',
                              onPressed: () {
                                setState(() {
                                  _isLiked = !_isLiked;
                                });
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    content: Text(
                                      _isLiked ? 'Article liked' : 'Article unliked',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                            EditorialIconButton(
                              icon: _isSaved
                                  ? Icons.bookmark
                                  : Icons.bookmark_border_rounded,
                              label: 'Save article',
                              onPressed: () {
                                setState(() {
                                  _isSaved = !_isSaved;
                                });
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    content: Text(
                                      _isSaved
                                          ? 'Added to Saved Stories'
                                          : 'Removed from Saved Stories',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                            EditorialIconButton(
                              icon: Icons.ios_share_rounded,
                              label: 'Share article',
                              onPressed: () => showEditorialShareSheet(
                                context,
                                title: _article.title,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bolt_rounded, size: 18, color: EditorialPalette.ink),
                          SizedBox(width: 6),
                          Text(
                            'Key Takeaways',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: EditorialPalette.ink,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Global demand shifts reflect critical vulnerabilities in regional supply resilience.\n• Regulatory agencies are tightening quality assurance and verification standards.\n• Distributed manufacturing hubs provide greater protection against future cross-border disruptions.',
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: EditorialPalette.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'A rapidly fluctuating global landscape has placed international pharmaceutical resilience squarely in the spotlight. Clinical practitioners emphasize that authentic generic compounds must undergo stringent verification protocols to safeguard public welfare.\n\nInternational regulatory bodies have begun coordinating with regional customs watchdogs to trace supply chains back to authorized laboratories. The objective is to balance swift humanitarian accessibility with unwavering pharmaceutical fidelity.\n\nAs digital verification stamps and tamper-evident cryptographic packaging gain wider adoption, patient advocacy groups remain hopeful that distributed production facilities will establish enduring protections against localized shortages.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: EditorialPalette.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
