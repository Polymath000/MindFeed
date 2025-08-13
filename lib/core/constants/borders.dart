import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/painting.dart' show BorderRadius, Radius;

@immutable
sealed class AppBorders {
  const AppBorders();
  static const double _main = 16;
  static const BorderRadius zero = BorderRadius.zero;
  static const BorderRadius xxxs = BorderRadius.all(Radius.circular(_main - 4));
  static const BorderRadius xxs = BorderRadius.all(Radius.circular(_main));
  static const BorderRadius xs = BorderRadius.all(Radius.circular(_main + 4));
  static const BorderRadius s = BorderRadius.all(Radius.circular(_main + 8));
  static const BorderRadius m = BorderRadius.all(Radius.circular(_main + 12));
  static const BorderRadius l = BorderRadius.all(Radius.circular(_main + 16));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(_main + 20));
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(_main + 24));
  static const BorderRadius circular = BorderRadius.all(Radius.circular(1000));
}
