import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';

class EditorialAvatar extends StatelessWidget {
  const EditorialAvatar({
    super.key,
    this.avatarUrl,
    this.avatarBytes,
    this.size = 40,
    this.fallbackName,
    this.backgroundColor = AppColors.blush,
    this.foregroundColor = AppColors.ink,
  });

  final String? avatarUrl;
  final Uint8List? avatarBytes;
  final double size;
  final String? fallbackName;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final decodeSize = (size * 3).round();

    if (avatarBytes != null && avatarBytes!.isNotEmpty) {
      return ClipOval(
        child: Image.memory(
          avatarBytes!,
          width: size,
          height: size,
          cacheWidth: decodeSize,
          cacheHeight: decodeSize,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildFallback(),
        ),
      );
    }

    final cleanUrl = avatarUrl?.trim();
    if (cleanUrl != null &&
        cleanUrl.isNotEmpty &&
        !cleanUrl.startsWith('assets/')) {
      return ClipOval(
        child: Image.network(
          cleanUrl,
          width: size,
          height: size,
          cacheWidth: decodeSize,
          cacheHeight: decodeSize,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildFallback(),
        ),
      );
    }

    return _buildFallback();
  }

  Widget _buildFallback() {
    final trimmedName = fallbackName?.trim() ?? '';
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: backgroundColor,
        child: trimmedName.isNotEmpty
            ? Text(
                trimmedName[0].toUpperCase(),
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: size * 0.38,
                  fontWeight: FontWeight.w800,
                ),
              )
            : Icon(
                AppIcons.personAlt,
                size: size * 0.5,
                color: foregroundColor,
              ),
      ),
    );
  }
}
