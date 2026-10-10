import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class PersonalInfromation extends StatelessWidget {
  const PersonalInfromation({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cream, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      Assets.assetsImagesWadeAvatar,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.blush,
                        child: Icon(AppIcons.personAlt, size: 48, color: AppColors.ink),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Abdelrahman Khaled',
                  style: TextStyle(
                    color: AppColors.softCream,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Senior Editorial Contributor • MindFeed',
                  style: TextStyle(
                    color: AppColors.greyText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatItem('14', 'Articles'),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      width: 1,
                      height: 32,
                      color: AppColors.borderDark,
                    ),
                    _buildStatItem('1.2K', 'Followers'),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      width: 1,
                      height: 32,
                      color: AppColors.borderDark,
                    ),
                    _buildStatItem('348', 'Following'),
                  ],
                ),
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
            color: AppColors.cream,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.greyText,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
