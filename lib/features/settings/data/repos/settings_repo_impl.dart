import 'package:mind_feed/core/constants/constants.dart';
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
    } on Failure catch (failure) {
      return FailureResult(failure);
    } catch (e) {
      final msg = e.toString().trim();
      return FailureResult(
        CacheFailure(msg.isNotEmpty ? msg : AppConstants.genericErrorMessage),
      );
    }
  }

  @override
  Future<ApiResult<ReaderPreferencesEntity>> updateReaderPreferences({
    String? fontScale,
  }) async {
    try {
      final updated = await localDataSource.updateReaderPreferences(
        fontScale: fontScale,
      );
      return Success(updated);
    } on Failure catch (failure) {
      return FailureResult(failure);
    } catch (e) {
      final msg = e.toString().trim();
      return FailureResult(
        CacheFailure(msg.isNotEmpty ? msg : AppConstants.genericErrorMessage),
      );
    }
  }
}
