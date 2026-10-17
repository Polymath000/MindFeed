import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';

class HomeFeedEmptyView extends StatelessWidget {
  const HomeFeedEmptyView({super.key, required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'No stories available for this topic.',
                textAlign: TextAlign.center,
                style: AppTextStyles.homeEmptyMessage,
              ),
              const SizedBox(height: 16),
              CustomButton(
                buttonText: 'Refresh',
                onTap: onRefresh,
                width: 140,
                height: 44,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
