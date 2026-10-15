import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/app_images.dart';

class AuthorCard extends StatelessWidget {
  const AuthorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.author);
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(Assets.assetsImagesWadeAvatar),
          ),
          SizedBox(width: 8),
          Text('Abdelrahman Khaled', style: AppTextStyles.bodyLarge),
          SizedBox(width: 8),
          TextButton(onPressed: () {}, child: Text('Follow')),
        ],
      ),
    );
  }
}
