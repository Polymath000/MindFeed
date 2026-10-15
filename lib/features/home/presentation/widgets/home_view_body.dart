import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_card_stack.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_mock_data.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/home/domain/usecases/get_home_feed_use_case.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody>
    with SingleTickerProviderStateMixin {
  String _selectedTopic = 'All';
  late final AnimationController _breathingController;
  late final Animation<double> _breathingAnimation;
  List<EditorialNewsItem>? _remoteStories;

  List<String> _topics = [
    'All',
    'Trending',
    'Tech',
    'Science',
    'Health',
    'Sports',
  ];

  @override
  void initState() {
    super.initState();
    _fetchRealStories();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);
    _breathingAnimation = CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOutSine,
    );
  }

  Future<void> _fetchRealStories() async {
    if (!getIt.isRegistered<GetHomeFeedUseCase>()) return;

    final preferredCategoryIds = <String>[];
    final dynamicFavoriteTopics = <String>[];

    User? user;
    try {
      user = Supabase.instance.client.auth.currentUser;
    } catch (_) {}
    if (user != null && getIt.isRegistered<ProfileRepository>()) {
      final favsResult = await getIt<ProfileRepository>().getFavoriteCategories(user.id);
      favsResult.when(
        success: (favs) {
          for (final f in favs) {
            final catId = f['category_id'] as String?;
            if (catId != null && catId.isNotEmpty && !preferredCategoryIds.contains(catId)) {
              preferredCategoryIds.add(catId);
            }
            final catObj = f['categories'] as Map<String, dynamic>?;
            final catName = catObj?['name'] as String?;
            if (catName != null && catName.isNotEmpty && !dynamicFavoriteTopics.contains(catName)) {
              dynamicFavoriteTopics.add(catName);
            }
          }
        },
        failure: (_) {},
      );
    }

    if (preferredCategoryIds.isEmpty && Hive.isBoxOpen(AppConstants.userKey)) {
      final box = Hive.box<UserEntity>(AppConstants.userKey);
      final localUser = box.get(AppConstants.userKey);
      final favNames = localUser?.favoriteCategories;
      if (favNames != null && favNames.isNotEmpty && getIt.isRegistered<ProfileRepository>()) {
        final catResult = await getIt<ProfileRepository>().getCategories();
        catResult.when(
          success: (allCats) {
            for (final c in allCats) {
              final name = c['name'] as String?;
              final id = c['id'] as String?;
              if (name != null && id != null && favNames.contains(name)) {
                if (!preferredCategoryIds.contains(id)) {
                  preferredCategoryIds.add(id);
                }
                if (!dynamicFavoriteTopics.contains(name)) {
                  dynamicFavoriteTopics.add(name);
                }
              }
            }
          },
          failure: (_) {},
        );
      }
    }

    final result = await getIt<GetHomeFeedUseCase>().call(
      preferredCategoryIds: preferredCategoryIds.isNotEmpty ? preferredCategoryIds : null,
    );

    if (!mounted) return;
    result.when(
      success: (articles) {
        if (articles.isNotEmpty) {
          setState(() {
            _remoteStories = articles.map((a) => a.toEditorialNewsItem()).toList();
            if (dynamicFavoriteTopics.isNotEmpty) {
              final newTopics = ['All', 'Trending', ...dynamicFavoriteTopics];
              for (final def in const ['Tech', 'Science', 'Health', 'Sports']) {
                if (!newTopics.contains(def)) {
                  newTopics.add(def);
                }
              }
              _topics = newTopics;
            }
          });
        }
      },
      failure: (_) {},
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  List<EditorialNewsItem> get _filteredStories {
    final all = _remoteStories ?? EditorialMockData.stories;
    if (_selectedTopic == 'All') return all;
    if (_selectedTopic == 'Trending') {
      return all
          .where((s) => s.isLive || s.badge == 'LIVE' || s.badge == 'TECH')
          .toList();
    }

    final topicLower = _selectedTopic.toLowerCase();
    final matching = all.where((s) {
      if (s.badge.toLowerCase() == topicLower) return true;
      if (s.categorySlug != null && s.categorySlug!.toLowerCase() == topicLower) return true;
      if (s.tags.any((t) => t.toLowerCase() == topicLower)) return true;
      return false;
    }).toList();
    if (matching.isNotEmpty) return matching;

    if (_selectedTopic == 'Tech') {
      return all.where((s) => s.badge == 'TECH' || s.badge == 'AI').toList();
    }
    if (_selectedTopic == 'Science') {
      return all
          .where((s) => s.badge == 'SCIENCE' || s.badge == 'SPACE')
          .toList();
    }
    if (_selectedTopic == 'Health') {
      return all.where((s) => s.badge == 'HEALTH').toList();
    }
    if (_selectedTopic == 'Sports') {
      return all.where((s) => s.badge == 'SPORT').toList();
    }
    return all;
  }

  @override
  Widget build(BuildContext context) {
    final stories = _filteredStories;

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _breathingAnimation,
            builder: (context, child) {
              final t = _breathingAnimation.value;
              return Stack(
                fit: StackFit.expand,
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.inkDarker,
                          AppColors.inkDarkest,
                          AppColors.almostBlack,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -140 + (t * 30),
                    left: -60 + (t * 25),
                    width: 440 + (t * 40),
                    height: 440 + (t * 40),
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Color.fromARGB((65 + (t * 40)).round(), 255, 222, 148),
                              Color.fromARGB((26 + (t * 20)).round(), 242, 185, 110),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.45, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150 - (t * 25),
                    right: -110 - (t * 20),
                    width: 380 + (t * 30),
                    height: 380 + (t * 30),
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Color.fromARGB((50 + ((1.0 - t) * 35)).round(), 230, 140, 120),
                              Color.fromARGB((20 + ((1.0 - t) * 18)).round(), 190, 100, 85),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80 + (t * 20),
                    left: -40 + (t * 20),
                    width: 320 + (t * 25),
                    height: 320 + (t * 25),
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Color.fromARGB((38 + (t * 25)).round(), 165, 190, 245),
                              Color.fromARGB((14 + (t * 12)).round(), 125, 150, 205),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(0.0, -0.35 + (t * 0.15)),
                            radius: 1.15 + (t * 0.25),
                            colors: [
                              Color.fromARGB((22 + (t * 22)).round(), 255, 240, 205),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.page,
                  12,
                  AppConstants.page,
                  24,
                ),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withAlpha(45),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withAlpha(70),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                Assets.assetsImagesMindFeedLogo,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'MindFeed',
                                  style: GoogleFonts.playfairDisplay(
                                    color: AppColors.softCream,
                                    fontSize: 29,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.6,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      EditorialIconButton(
                        icon: AppIcons.gridViewRounded,
                        label: 'Open profile',
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _topics.map((topic) {
                        final isSelected = topic == _selectedTopic;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTopic = topic;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.cream
                                    : Colors.white.withAlpha(15),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.yellowHighlight
                                      : Colors.white.withAlpha(24),
                                  width: isSelected ? 1.2 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.cream
                                              .withAlpha(65),
                                          blurRadius: 12,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                topic,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.ink
                                      : AppColors.softCream
                                          .withAlpha(185),
                                  fontSize: 14.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  EditorialCardStack(
                    key: ValueKey(_selectedTopic),
                    items: stories,
                    height: 570,
                    onOpenArticle: (item) =>
                        Navigator.pushNamed(context, AppRoutes.article, arguments: item),
                    onDismiss: (item) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text('Swiped: ${item.title.split('\n').first}'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
