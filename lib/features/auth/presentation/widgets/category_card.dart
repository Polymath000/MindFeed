import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    this.category,
    this.title,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final dynamic category;
  final String? title;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  String get _title {
    if (title != null && title!.isNotEmpty) return title!;
    if (category is List && (category as List).isNotEmpty) {
      return (category as List)[0].toString();
    }
    try {
      return (category as dynamic).name.toString();
    } catch (_) {
      return '';
    }
  }

  IconData get _icon {
    if (icon != null) return icon!;
    try {
      return (category as dynamic).icon as IconData;
    } catch (_) {
      return AppIcons.getCategoryIcon(_title);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fgColor = isSelected ? AppColors.ink : AppColors.white;
    final bgColor = isSelected ? AppColors.white : AppColors.charcoal;
    final borderColor = isSelected ? AppColors.white : AppColors.borderDark;

    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        splashColor: (isSelected ? AppColors.ink : AppColors.white)
            .withValues(alpha: 0.15),
        highlightColor: (isSelected ? AppColors.ink : AppColors.white)
            .withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon, size: 18, color: fgColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _title,
                  style:
                      (AppTextStyles.bodyMedium ?? const TextStyle()).copyWith(
                    color: fgColor,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                Icon(Icons.check, size: 14, color: fgColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}



