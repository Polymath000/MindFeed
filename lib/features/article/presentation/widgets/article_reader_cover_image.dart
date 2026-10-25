import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/borders.dart';

class ArticleReaderCoverImage extends StatelessWidget {
  const ArticleReaderCoverImage({
    super.key,
    this.coverImageUrl,
    this.coverImageBytes,
    this.overlay,
  });

  final String? coverImageUrl;
  final Uint8List? coverImageBytes;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: AppBorders.s,
          child: _buildImage(),
        ),
        if (overlay != null) Positioned(right: 14, bottom: 14, child: overlay!),
      ],
    );
  }

  Widget _buildImage() {
    if (coverImageBytes != null && coverImageBytes!.isNotEmpty) {
      return Image.memory(
        coverImageBytes!,
        height: 240,
        width: double.infinity,
        cacheWidth: 1080,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }

    final resolvedUrl = coverImageUrl?.trim();
    if (resolvedUrl != null &&
        resolvedUrl.isNotEmpty &&
        !resolvedUrl.startsWith('assets/')) {
      return Image.network(
        resolvedUrl,
        height: 240,
        width: double.infinity,
        cacheWidth: 1080,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() => Container(
        height: 180,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.blackAlpha12,
          borderRadius: AppBorders.s,
        ),
        child: const Center(
          child: Icon(
            AppIcons.articleOutlined,
            size: 40,
            color: AppColors.mutedInk,
          ),
        ),
      );
}
