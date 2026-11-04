import 'package:mind_feed/core/networking/api_result.dart';

import '../entities/reader_preferences_entity.dart';
import '../repos/settings_repo.dart';

class GetReaderPreferencesUseCase {
  final SettingsRepository repository;

  const GetReaderPreferencesUseCase(this.repository);

  Future<ApiResult<ReaderPreferencesEntity>> call() async {
    return await repository.getReaderPreferences();
  }
}
