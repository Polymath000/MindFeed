import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';

class ArticleReaderTopBar extends StatelessWidget {
  const ArticleReaderTopBar({
    super.key,
    required this.badge,
    required this.badgeColor,
    this.onBack,
  });

  final String badge;
  final Color badgeColor;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _BackButton(onBack: onBack),
        _BadgeLabel(badge: badge, color: badgeColor),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: InkResponse(
        onTap: onBack ?? () => Navigator.maybePop(context),
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.blackAlpha20,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            AppIcons.arrowBackRounded,
            color: AppColors.ink,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _BadgeLabel extends StatelessWidget {
  const _BadgeLabel({required this.badge, required this.color});
  final String badge;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppBorders.badge,
      ),
      child: Text(badge, style: AppTextStyles.readerTopBadge),
    );
  }
}
