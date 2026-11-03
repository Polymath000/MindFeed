import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_result.dart';

import '../../domain/entities/reader_preferences_entity.dart';
import '../../domain/repos/settings_repo.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  const SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<ApiResult<ReaderPreferencesEntity>> getReaderPreferences() async {
    try {
      final preferences = await localDataSource.getReaderPreferences();
      return Success(preferences);
    } catch (e) {
      return FailureResult(CacheFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<ReaderPreferencesEntity>> updateReaderPreferences({
    String? fontScale,
    bool? serifMode,
  }) async {
    try {
      final updated = await localDataSource.updateReaderPreferences(
        fontScale: fontScale,
        serifMode: serifMode,
      );
      return Success(updated);
    } catch (e) {
      return FailureResult(CacheFailure(e.toString()));
    }
  }
}
