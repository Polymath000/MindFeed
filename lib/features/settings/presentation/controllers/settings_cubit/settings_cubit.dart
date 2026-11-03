import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/clear_downloaded_articles_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_archive_cache_size_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_settings_profile_use_case.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsProfileUseCase getSettingsProfileUseCase;
  final GetArchiveCacheSizeUseCase getArchiveCacheSizeUseCase;
  final ClearDownloadedArticlesUseCase clearDownloadedArticlesUseCase;
  final LogoutUseCase logoutUseCase;

  SettingsCubit({
    required this.getSettingsProfileUseCase,
    required this.getArchiveCacheSizeUseCase,
    required this.clearDownloadedArticlesUseCase,
    required this.logoutUseCase,
  }) : super(const SettingsInitial());

  Future<void> loadSettings() async {
    _loadPreferences();
    await Future.wait([
      loadUserData(),
      loadCacheSize(),
    ]);
  }

  void _loadPreferences() {
    try {
      final fontScale =
          SharedPreferencesSingleton.getString('pref_font_scale') ?? 'Standard';
      final serifMode =
          SharedPreferencesSingleton.getBool('pref_serif_mode') ?? true;

      emit(SettingsLoaded(
        displayName: state.displayName,
        userEmail: state.userEmail,
        avatarUrl: state.avatarUrl,
        currentUserEntity: state.currentUserEntity,
        fontScale: fontScale,
        serifMode: serifMode,
        cachedMegabytes: state.cachedMegabytes,
      ));
    } catch (_) {
      emit(SettingsLoaded(
        displayName: state.displayName,
        userEmail: state.userEmail,
        avatarUrl: state.avatarUrl,
        currentUserEntity: state.currentUserEntity,
        fontScale: state.fontScale,
        serifMode: state.serifMode,
        cachedMegabytes: state.cachedMegabytes,
      ));
    }
  }

  Future<void> loadUserData() async {
    final result = await getSettingsProfileUseCase();
    if (isClosed) return;
    result.when(
      success: (summary) {
        if (!isClosed) {
          emit(SettingsLoaded(
            displayName: summary.displayName,
            userEmail: summary.userEmail,
            avatarUrl: summary.avatarUrl,
            currentUserEntity: summary.userEntity,
            fontScale: state.fontScale,
            serifMode: state.serifMode,
            cachedMegabytes: state.cachedMegabytes,
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
          emit(SettingsLoaded(
            displayName: state.displayName,
            userEmail: state.userEmail,
            avatarUrl: state.avatarUrl,
            currentUserEntity: state.currentUserEntity,
            fontScale: state.fontScale,
            serifMode: state.serifMode,
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
          emit(SettingsLoaded(
            displayName: state.displayName,
            userEmail: state.userEmail,
            avatarUrl: state.avatarUrl,
            currentUserEntity: state.currentUserEntity,
            fontScale: state.fontScale,
            serifMode: state.serifMode,
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

  void setFontScale(String val) {
    try {
      SharedPreferencesSingleton.setString('pref_font_scale', val);
    } catch (_) {}
    if (!isClosed) {
      emit(SettingsLoaded(
        displayName: state.displayName,
        userEmail: state.userEmail,
        avatarUrl: state.avatarUrl,
        currentUserEntity: state.currentUserEntity,
        fontScale: val,
        serifMode: state.serifMode,
        cachedMegabytes: state.cachedMegabytes,
      ));
    }
  }

  void setSerifMode(bool value) {
    try {
      SharedPreferencesSingleton.setBool('pref_serif_mode', value: value);
    } catch (_) {}
    if (!isClosed) {
      emit(SettingsLoaded(
        displayName: state.displayName,
        userEmail: state.userEmail,
        avatarUrl: state.avatarUrl,
        currentUserEntity: state.currentUserEntity,
        fontScale: state.fontScale,
        serifMode: value,
        cachedMegabytes: state.cachedMegabytes,
      ));
    }
  }
}
