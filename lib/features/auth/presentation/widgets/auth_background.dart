import 'package:flutter/material.dart';
import 'package:mind_feed/core/utls/app_images.dart';

Image authBackground() {
  return Image.asset(
    Assets.assetsImagesBack,
    height: double.infinity,
    width: double.infinity,
    fit: BoxFit.cover,
  );
}
