import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_images.dart';

class SplashLogoWidget extends StatefulWidget {
  const SplashLogoWidget({super.key});

  @override
  State<SplashLogoWidget> createState() => _SplashLogoWidgetState();
}

class _SplashLogoWidgetState extends State<SplashLogoWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathingController;
  late final Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _breathingAnimation = Tween<double>(begin: 0.95, end: 1.03).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _breathingAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFF1B1A18),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF423D33), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(90),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Image.asset(
              Assets.assetsImagesMindFeedLogo,
              cacheWidth: 168,
              cacheHeight: 168,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'MindFeed',
            style: GoogleFonts.playfairDisplay(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.softCream,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 28,
            height: 1.2,
            color: const Color(0xFFB59359),
          ),
          const Text(
            'THE CURATED EDITION',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 3.0,
              color: Color(0xFF8F887C),
            ),
          ),
        ],
      ),
    );
  }
}
