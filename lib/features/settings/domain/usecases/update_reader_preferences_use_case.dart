import 'package:mind_feed/core/networking/api_result.dart';

import '../entities/reader_preferences_entity.dart';
import '../repos/settings_repo.dart';

class UpdateReaderPreferencesUseCase {
  final SettingsRepository repository;

  const UpdateReaderPreferencesUseCase(this.repository);

  Future<ApiResult<ReaderPreferencesEntity>> call({
    String? fontScale,
  }) async {
    return await repository.updateReaderPreferences(
      fontScale: fontScale,
    );
  }
}
