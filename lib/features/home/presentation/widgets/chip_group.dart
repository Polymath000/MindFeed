import 'package:flutter/material.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';

class ChipGroup extends StatelessWidget {
  const ChipGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          SlideInRight(
            config: BaseAnimationConfig(
              child: ChoiceChip(label: Text('All'), selected: true),
            ),
          ),
          const SizedBox(width: 10),
          SlideInRight(
            config: const BaseAnimationConfig(
              delay: Duration(milliseconds: 300),
              child: ChoiceChip(label: Text('Technology'), selected: true),
            ),
          ),
          const SizedBox(width: 10),
          SlideInRight(
            config: const BaseAnimationConfig(
              delay: Duration(milliseconds: 350),
              child: ChoiceChip(label: Text('Sports'), selected: false),
            ),
          ),
          const SizedBox(width: 10),
          SlideInRight(
            config: const BaseAnimationConfig(
              delay: Duration(milliseconds: 400),
              child: ChoiceChip(label: Text('Just for test'), selected: false),
            ),
          ),
        ],
      ),
    );
  }
}
