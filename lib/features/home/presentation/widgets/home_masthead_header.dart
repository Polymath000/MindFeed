import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/constants/constants.dart';

class HomeMastheadHeader extends StatelessWidget {
  const HomeMastheadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _MastheadBrandLogo(),
        SizedBox(width: 12),
        Expanded(child: HomeMastheadAnimatedTitle()),
      ],
    );
  }
}

class _MastheadBrandLogo extends StatelessWidget {
  const _MastheadBrandLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.whiteAlpha45,
            blurRadius: 12,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: AppColors.blackAlpha70,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(5),
      child: Image.asset(
        Assets.assetsImagesMindFeedLogo,
        cacheWidth: 96,
        cacheHeight: 96,
        fit: BoxFit.contain,
      ),
    );
  }
}

class HomeMastheadAnimatedTitle extends StatelessWidget {
  const HomeMastheadAnimatedTitle({
    super.key,
    this.words = AppConstants.mastheadRotatingWords,
  });

  final List<String> words;

  List<AnimatedText> _buildAnimatedTexts() {
    final effectiveWords =
        words.isEmpty ? const [AppConstants.appName] : words;
    final style = AppTextStyles.homeMastheadTitle;
    return [
      for (final word in effectiveWords)
        RotateAnimatedText(
          word,
          textStyle: style,
          alignment: Alignment.centerLeft,
          transitionHeight: 42,
          duration: const Duration(milliseconds: 2400),
        ),
      RotateAnimatedText(
        effectiveWords.first,
        textStyle: style,
        alignment: Alignment.centerLeft,
        transitionHeight: 42,
        duration: const Duration(milliseconds: 1600),
        rotateOut: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: 42,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: AnimatedTextKit(
            repeatForever: false,
            totalRepeatCount: 1,
            pause: const Duration(milliseconds: 1000),
            animatedTexts: _buildAnimatedTexts(),
          ),
        ),
      ),
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

  List<String> get _displayTopics => <String>[
        'All',
        ...topics
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty && t.toLowerCase() != 'all'),
      ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final topic in _displayTopics)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _TopicTabPill(
                topic: topic,
                isSelected: topic == selectedTopic,
                onTap: () => onTopicSelected(topic),
              ),
            ),
        ],
      ),
    );
  }
}

class _TopicTabPill extends StatelessWidget {
  const _TopicTabPill({
    required this.topic,
    required this.isSelected,
    required this.onTap,
  });

  final String topic;
  final bool isSelected;
  final VoidCallback onTap;

  BoxDecoration _buildDecoration() => BoxDecoration(
        color: isSelected ? AppColors.cream : AppColors.whiteAlpha15,
        borderRadius: AppBorders.pill,
        border: Border.all(
          color: isSelected
              ? AppColors.yellowHighlight
              : AppColors.whiteAlpha24,
          width: isSelected ? 1.2 : 1.0,
        ),
        boxShadow: isSelected
            ? const [
                BoxShadow(
                  color: AppColors.creamAlpha65,
                  blurRadius: 12,
                  offset: Offset(0, 3),
                ),
              ]
            : null,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: _buildDecoration(),
        child: Text(
          topic,
          style: isSelected
              ? AppTextStyles.homeTopicSelected
              : AppTextStyles.homeTopicUnselected,
        ),
      ),
    );
  }
}
