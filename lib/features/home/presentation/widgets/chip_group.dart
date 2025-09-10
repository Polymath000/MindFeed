import 'package:flutter/material.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';

class ChipGroup extends StatelessWidget {
  const ChipGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          SlideInRight(
            config: BaseAnimationConfig(
              child: ChoiceChip(
                label: Text(
                  'All',
                  style: AppTextStyles.bodyMedium!.copyWith(
                    color: AppColors.white,
                  ),
                ),
                selected: false,
                backgroundColor: AppColors.white,
                color: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.blue.shade700; // Darker blue when pressed
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.blue.shade300; // Lighter blue when hovered
                  }
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.grey; // Grey when disabled
                  }
                  return Colors.blue; // Default blue
                }),
              ),
            ),
          ),
          SizedBox(width: 10),
          SlideInRight(
            config: BaseAnimationConfig(
              delay: Duration(milliseconds: 300),
              child: ChoiceChip(label: Text('Technology'), selected: false),
            ),
          ),
          SizedBox(width: 10),
          SlideInRight(
            config: BaseAnimationConfig(
              delay: Duration(milliseconds: 350),
              child: ChoiceChip(label: Text('Sports'), selected: false),
            ),
          ),
          SizedBox(width: 10),
          SlideInRight(
            config: BaseAnimationConfig(
              delay: Duration(milliseconds: 400),
              child: ChoiceChip(label: Text('Just for test'), selected: false),
            ),
          ),
        ],
      ),
    );
  }
}
