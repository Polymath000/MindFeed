import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/borders.dart';

class EditorialIconButton extends StatelessWidget {
  const EditorialIconButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.light = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool light;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: Tooltip(
      message: label,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: light ? AppColors.ink : AppColors.softCream),
        iconSize: 21,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        style: IconButton.styleFrom(
          backgroundColor: light ? AppColors.cream : AppColors.ink,
          foregroundColor: light ? AppColors.ink : AppColors.softCream,
          shape: const RoundedRectangleBorder(borderRadius: AppBorders.control),
        ),
      ),
    ),
  );
}

class EditorialFollowButton extends StatelessWidget {
  const EditorialFollowButton({
    super.key,
    this.authorName = 'Author',
    this.isFollowing = false,
    this.isLoading = false,
    this.onPressed,
    this.darkSurface = false,
  });

  final String authorName;
  final bool isFollowing;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool darkSurface;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isFollowing
        ? AppColors.cream
        : (darkSurface ? AppColors.inkDark : AppColors.ink);
    final foregroundColor = isFollowing ? AppColors.ink : AppColors.softCream;

    return Semantics(
      button: true,
      label: isFollowing ? 'Unfollow $authorName' : 'Follow $authorName',
      child: SizedBox(
        height: 38,
        child: FilledButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: isLoading
              ? SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                  ),
                )
              : Icon(
                  isFollowing ? AppIcons.checkRounded : AppIcons.add,
                  size: 16,
                  color: foregroundColor,
                ),
          label: Text(
            isFollowing ? 'Following' : 'Follow',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: foregroundColor,
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            disabledBackgroundColor: backgroundColor,
            elevation: isFollowing ? 1 : 0,
            minimumSize: const Size(82, 38),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            shape: const RoundedRectangleBorder(
              borderRadius: AppBorders.control,
              side: BorderSide(color: AppColors.borderDark),
            ),
          ),
        ),
      ),
    );
  }
}
