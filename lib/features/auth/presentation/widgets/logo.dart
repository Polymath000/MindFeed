import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/utls/app_images.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF262422),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF383530), width: 1.5),
            ),
            child: SvgPicture.asset(
              Assets.assetsImagesLogo,
              height: 52,
              width: 52,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'MindFeed',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              color: EditorialPalette.softCream,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Curated intelligence for curious minds',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: Color(0xFFAAA49B),
            ),
          ),
        ],
      ),
    );
  }
}
