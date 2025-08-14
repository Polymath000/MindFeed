import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_feed/core/utls/app_images.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80.0),
      child: Center(
        child: SvgPicture.asset(
          Assets.assetsImagesLogo,
          height: 100,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
