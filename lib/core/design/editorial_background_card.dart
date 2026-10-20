import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_card.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

class EditorialBackgroundCard extends StatelessWidget {
  const EditorialBackgroundCard({
    super.key,
    required this.item,
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
    required this.opacity,
    required this.onOpen,
  });

  final EditorialNewsItem item;
  final double left;
  final double right;
  final double top;
  final double bottom;
  final double opacity;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: RepaintBoundary(
        child: EditorialCard(
          item: item,
          backgroundColor: Color.lerp(AppColors.ink, item.color, opacity),
          showActions: false,
          onOpen: onOpen,
        ),
      ),
    );
  }
}
