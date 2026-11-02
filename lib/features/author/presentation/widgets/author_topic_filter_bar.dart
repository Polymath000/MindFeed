import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';

class AuthorTopicFilterBar extends StatelessWidget {
  final List<String> topics;
  final String? selectedTopic;
  final ValueChanged<String?> onTopicSelected;

  const AuthorTopicFilterBar({
    super.key,
    required this.topics,
    this.selectedTopic,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (topics.length <= 1) {
      return const SizedBox.shrink();
    }

    final allTopics = ['All', ...topics];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: allTopics.map((topic) {
          final isAll = topic == 'All';
          final isSelected = isAll
              ? selectedTopic == null
              : selectedTopic?.trim().toLowerCase() ==
                  topic.trim().toLowerCase();

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: 'Filter by $topic',
              child: InkWell(
                onTap: () => onTopicSelected(isAll ? null : topic),
                borderRadius: AppBorders.control,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.cream : AppColors.charcoal,
                    borderRadius: AppBorders.control,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.cream
                          : AppColors.borderDark,
                    ),
                  ),
                  child: Text(
                    topic,
                    style: TextStyle(
                      color: isSelected ? AppColors.ink : AppColors.softCream,
                      fontSize: 12.5,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
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
