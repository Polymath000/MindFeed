import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

Widget authBackground() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: const BoxDecoration(
      color: EditorialPalette.ink,
      gradient: RadialGradient(
        center: Alignment(0.0, -0.6),
        radius: 1.2,
        colors: [
          Color(0xFF24221E),
          EditorialPalette.ink,
        ],
      ),
    ),
  );
}
