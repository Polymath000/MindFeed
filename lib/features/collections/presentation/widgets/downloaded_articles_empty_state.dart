import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';

class DownloadedArticlesEmptyState extends StatelessWidget {
  final String searchQuery;
  final bool isDark;

  const DownloadedArticlesEmptyState({
    super.key,
    required this.searchQuery,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                AppIcons.inventory2Outlined,
                size: 56,
                color: isDark ? AppColors.greyText : AppColors.mutedInk,
              ),
              const SizedBox(height: 16),
              Text(
                searchQuery.isEmpty
                    ? 'No Downloaded Articles'
                    : 'No Matching Articles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                searchQuery.isEmpty
                    ? 'Articles saved for offline reading will appear here.'
                    : 'No downloads matched "$searchQuery".',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.greyText : AppColors.mutedInk,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
