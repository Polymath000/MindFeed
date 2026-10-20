import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';

class EditorialCardFeedbackBadge extends StatelessWidget {
  const EditorialCardFeedbackBadge({
    super.key,
    required this.dragOffsetListenable,
  });

  final ValueListenable<Offset> dragOffsetListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: dragOffsetListenable,
      builder: (context, dragOffset, _) {
        if (dragOffset.dx.abs() <= 24) return const SizedBox.shrink();
        final isSave = dragOffset.dx > 24;
        return Positioned(
          top: 14,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSave ? AppColors.yellowHighlight : AppColors.ink,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSave
                        ? AppIcons.bookmarkFilled
                        : Icons.arrow_forward_rounded,
                    size: 16,
                    color: isSave ? AppColors.ink : AppColors.softCream,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isSave ? 'SAVE' : 'NEXT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: isSave ? AppColors.ink : AppColors.softCream,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
