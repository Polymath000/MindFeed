extension StringExtension on String {
  /// Capitalizes the first letter
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';

  /// Reverses the string
  String get reversed => split('').reversed.join();

  int? toInt() => int.tryParse(this);

  double? toDouble() => double.tryParse(this);

  num? toNum() => num.tryParse(this);

  DateTime toDateTime() => DateTime.parse(this);

  T? toEnum<T extends Enum?>(
    final List<T?>? values, [
    final Map<T, dynamic>? map,
  ]) => values?.firstWhere(
    (final e) =>
        e?.name.toLowerCase() == toLowerCase() ||
        e?.toString().toLowerCase() == toLowerCase() ||
        map?[e].toString().toLowerCase() == toLowerCase(),
    orElse: () => throw ArgumentError(
      'No enum value found for $this in '
      '${values.map((final e) => e?.name).join(', ')}',
    ),
  );
}
