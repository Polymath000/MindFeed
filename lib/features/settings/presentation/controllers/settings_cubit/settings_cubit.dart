import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            serifMode: prefs.serifMode,
          ));
        }
      },
      failure: (_) {
        if (!isClosed) {
          emit(state.toLoaded());
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
      failure: (_) {},
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
      failure: (_) {},
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
      failure: (_) {},
    );
  }

  Future<ApiResult<void>> signOut() async {
    return await logoutUseCase();
  }

  Future<void> setFontScale(String val) async {
    if (!isClosed) {
      emit(state.toLoaded(fontScale: val));
    }
    await updateReaderPreferencesUseCase(fontScale: val);
  }

  Future<void> setSerifMode(bool value) async {
    if (!isClosed) {
      emit(state.toLoaded(serifMode: value));
    }
    await updateReaderPreferencesUseCase(serifMode: value);
  }
}
