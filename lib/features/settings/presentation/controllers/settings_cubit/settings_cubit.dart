import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:mind_feed/features/settings/data/repos/settings_repo_impl.dart';
import 'package:mind_feed/features/settings/domain/usecases/clear_downloaded_articles_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_archive_cache_size_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_reader_preferences_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_settings_profile_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/update_reader_preferences_use_case.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsProfileUseCase getSettingsProfileUseCase;
  final GetArchiveCacheSizeUseCase getArchiveCacheSizeUseCase;
  final ClearDownloadedArticlesUseCase clearDownloadedArticlesUseCase;
  final LogoutUseCase logoutUseCase;
  final GetReaderPreferencesUseCase getReaderPreferencesUseCase;
  final UpdateReaderPreferencesUseCase updateReaderPreferencesUseCase;

  SettingsCubit({
    required this.getSettingsProfileUseCase,
    required this.getArchiveCacheSizeUseCase,
    required this.clearDownloadedArticlesUseCase,
    required this.logoutUseCase,
    GetReaderPreferencesUseCase? getReaderPreferencesUseCase,
    UpdateReaderPreferencesUseCase? updateReaderPreferencesUseCase,
  })  : getReaderPreferencesUseCase = getReaderPreferencesUseCase ??
            const GetReaderPreferencesUseCase(
              SettingsRepositoryImpl(SettingsLocalDataSourceImpl()),
            ),
        updateReaderPreferencesUseCase = updateReaderPreferencesUseCase ??
            const UpdateReaderPreferencesUseCase(
              SettingsRepositoryImpl(SettingsLocalDataSourceImpl()),
            ),
        super(const SettingsInitial());

  Future<void> loadSettings() async {
    await _loadPreferences();
    await Future.wait([
      loadUserData(),
      loadCacheSize(),
    ]);
  }

  Future<void> _loadPreferences() async {
    final result = await getReaderPreferencesUseCase();
    if (isClosed) return;
    result.when(
      success: (prefs) {
        if (!isClosed) {
          emit(state.toLoaded(
            fontScale: prefs.fontScale,
          ));
        }
      },
      failure: (failure) {
        if (!isClosed) {
          emit(state.toError(
            failure.message.isNotEmpty
                ? failure.message
                : AppConstants.genericErrorMessage,
          ));
        }
      },
    );
  }

  Future<void> loadUserData() async {
    final result = await getSettingsProfileUseCase();
    if (isClosed) return;
    result.when(
      success: (summary) {
        if (!isClosed) {
          emit(state.toLoaded(
            displayName: summary.displayName,
            userEmail: summary.userEmail,
            avatarUrl: summary.avatarUrl,
            currentUserEntity: summary.userEntity,
          ));
        }
      },
      failure: (failure) {
        if (!isClosed) {
          emit(state.toError(
            failure.message.isNotEmpty
                ? failure.message
                : AppConstants.genericErrorMessage,
          ));
        }
      },
    );
  }

  Future<void> loadCacheSize() async {
    final result = await getArchiveCacheSizeUseCase();
    if (isClosed) return;
    result.when(
      success: (sizeMb) {
        if (!isClosed) {
          emit(state.toLoaded(
            cachedMegabytes: sizeMb,
          ));
        }
      },
      failure: (failure) {
        if (!isClosed) {
          emit(state.toError(
            failure.message.isNotEmpty
                ? failure.message
                : AppConstants.genericErrorMessage,
          ));
        }
      },
    );
  }

  Future<void> clearCache() async {
    final result = await clearDownloadedArticlesUseCase();
    if (isClosed) return;
    result.when(
      success: (_) {
        if (!isClosed) {
          emit(state.toLoaded(
            cachedMegabytes: 0.0,
          ));
        }
      },
      failure: (failure) {
        if (!isClosed) {
          emit(state.toError(
            failure.message.isNotEmpty
                ? failure.message
                : AppConstants.genericErrorMessage,
          ));
        }
      },
    );
  }

  Future<ApiResult<void>> signOut() async {
    return await logoutUseCase();
  }

  Future<void> setFontScale(String val) async {
    if (!isClosed) {
      emit(state.toLoaded(fontScale: val));
    }
    final result = await updateReaderPreferencesUseCase(fontScale: val);
    if (isClosed) return;
    result.when(
      success: (_) {},
      failure: (failure) {
        if (!isClosed) {
          emit(state.toError(
            failure.message.isNotEmpty
                ? failure.message
                : AppConstants.genericErrorMessage,
          ));
        }
      },
    );
  }

}
