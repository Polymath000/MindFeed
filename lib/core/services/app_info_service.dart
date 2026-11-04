import 'package:flutter/foundation.dart' show immutable, visibleForTesting;
import 'package:package_info_plus/package_info_plus.dart';

@immutable
sealed class AppInfoService {
  const AppInfoService();
  static PackageInfo? _instance;

  static bool get isInitialized => _instance != null;

  static Future<PackageInfo> init() async {
    _instance = await PackageInfo.fromPlatform();
    return _instance!;
  }

  static PackageInfo? get instance => _instance;

  static String get appName =>
      _instance?.appName.isNotEmpty == true ? _instance!.appName : 'MindFeed';

  static String get version =>
      _instance?.version.isNotEmpty == true ? _instance!.version : '1.0.0';

  static String get buildNumber =>
      _instance?.buildNumber.isNotEmpty == true ? _instance!.buildNumber : '1';

  static String get versionWithBuild => '$version+$buildNumber';

  static String get formattedStamp => 'v$versionWithBuild';

  @visibleForTesting
  static void setMockInstance(PackageInfo info) {
    _instance = info;
  }

  @visibleForTesting
  static void reset() {
    _instance = null;
  }
}
