import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/utls/app_images.dart';

class AuthorCard extends StatelessWidget {
  const AuthorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.authorView(context);
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(Assets.assetsImagesMeJustForTest),
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
