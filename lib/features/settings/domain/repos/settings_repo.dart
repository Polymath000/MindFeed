import 'package:mind_feed/core/networking/api_result.dart';

import '../entities/reader_preferences_entity.dart';

abstract class SettingsRepository {
  Future<ApiResult<ReaderPreferencesEntity>> getReaderPreferences();
  Future<ApiResult<ReaderPreferencesEntity>> updateReaderPreferences({
    String? fontScale,
  });
}
