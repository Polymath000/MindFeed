import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/utls/app_images.dart';

class PersonalInfromation extends StatelessWidget {
  const PersonalInfromation({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0, bottom: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(Assets.assetsImagesMeJustForTest),
                  radius: 60,
                ),
                const SizedBox(height: 12),
                Text(
                  'Abdelrahman Khaled',
                  style: AppTextStyles.titleLarge!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'abdalrahmankhaled642004@gmail.com',
                  style: AppTextStyles.titleMedium!.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatItem("1.2K", "Followers"),
                const SizedBox(width: 32),
                _buildStatItem("348", "Following"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.cyan,
            fontSize: 25,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkGrey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
