import 'package:mind_feed/core/constants/constants.dart';

class ReaderPreferencesEntity {
  final String fontScale;

  const ReaderPreferencesEntity({
    this.fontScale = AppConstants.defaultFontScale,
  });

  ReaderPreferencesEntity copyWith({
    String? fontScale,
  }) {
    return ReaderPreferencesEntity(
      fontScale: fontScale ?? this.fontScale,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReaderPreferencesEntity && other.fontScale == fontScale;
  }

  @override
  int get hashCode => fontScale.hashCode;
}
