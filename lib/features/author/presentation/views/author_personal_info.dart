import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/constants/app_images.dart';

class AuthorPersonalInfo extends StatelessWidget {
  const AuthorPersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: EditorialPalette.cream, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  Assets.assetsImagesWadeAvatar,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const CircleAvatar(
                    radius: 48,
                    backgroundColor: EditorialPalette.blush,
                    child: Icon(Icons.person, size: 48, color: EditorialPalette.ink),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Wade Warren',
              style: TextStyle(
                color: EditorialPalette.softCream,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Investigative Tech & Science Lead • MindFeed',
              style: TextStyle(
                color: Color(0xFFAAA49B),
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            const EditorialFollowButton(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatItem('86', 'Stories'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: 1,
                  height: 32,
                  color: const Color(0xFF383530),
                ),
                _buildStatItem('48.2K', 'Followers'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: 1,
                  height: 32,
                  color: const Color(0xFF383530),
                ),
                _buildStatItem('192', 'Following'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: EditorialPalette.cream,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFAAA49B),
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
