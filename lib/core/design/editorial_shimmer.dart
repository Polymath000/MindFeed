import 'package:flutter/foundation.dart' show immutable;

import 'package:skeletonizer/skeletonizer.dart';

import 'package:mind_feed/core/constants/app_colors.dart';

@immutable
sealed class EditorialShimmer {
  const EditorialShimmer();

  static const ShimmerEffect paperEffect = ShimmerEffect(
    baseColor: AppColors.greyBrown,
    highlightColor: AppColors.creamDark,
  );

  static const ShimmerEffect darkEffect = ShimmerEffect(
    baseColor: AppColors.borderDark,
    highlightColor: AppColors.mutedInk,
  );
}
