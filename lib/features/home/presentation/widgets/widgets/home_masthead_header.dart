import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class HomeMastheadHeader extends StatelessWidget {
  const HomeMastheadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class HomeTopicTabsBar extends StatelessWidget {
  const HomeTopicTabsBar({
    super.key,
    required this.topics,
    required this.selectedTopic,
    required this.onTopicSelected,
  });

  final List<String> topics;
  final String selectedTopic;
  final ValueChanged<String> onTopicSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: topics.map((topic) {
          final isSelected = topic == selectedTopic;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => onTopicSelected(topic),
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
                            color: AppColors.cream.withAlpha(65),
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
                        : AppColors.softCream.withAlpha(185),
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
    );
  }
}
