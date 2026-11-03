import 'package:mind_feed/core/constants/constants.dart';

class ReaderPreferencesEntity {
  final String fontScale;
  final bool serifMode;

  const ReaderPreferencesEntity({
    this.fontScale = AppConstants.defaultFontScale,
    this.serifMode = true,
  });

  ReaderPreferencesEntity copyWith({
    String? fontScale,
    bool? serifMode,
  }) {
    return ReaderPreferencesEntity(
      fontScale: fontScale ?? this.fontScale,
      serifMode: serifMode ?? this.serifMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReaderPreferencesEntity &&
        other.fontScale == fontScale &&
        other.serifMode == serifMode;
  }

  @override
  int get hashCode => Object.hash(fontScale, serifMode);
}
