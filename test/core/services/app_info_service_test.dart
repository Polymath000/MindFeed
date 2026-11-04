import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:mind_feed/core/services/app_info_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    AppInfoService.reset();
  });

  tearDown(() {
    AppInfoService.reset();
  });

  group('AppInfoService', () {
    test('returns safe default fallback values when uninitialized', () {
      expect(AppInfoService.isInitialized, isFalse);
      expect(AppInfoService.instance, isNull);
      expect(AppInfoService.appName, 'MindFeed');
      expect(AppInfoService.version, '1.0.0');
      expect(AppInfoService.buildNumber, '1');
      expect(AppInfoService.versionWithBuild, '1.0.0+1');
      expect(AppInfoService.formattedStamp, 'v1.0.0+1');
    });

    test('returns exact values when mock instance is configured', () {
      final mockInfo = PackageInfo(
        appName: 'MindFeed Editorial',
        packageName: 'mind.feed.app',
        version: '2.5.0',
        buildNumber: '42',
        buildSignature: '',
        installerStore: null,
      );

      AppInfoService.setMockInstance(mockInfo);

      expect(AppInfoService.isInitialized, isTrue);
      expect(AppInfoService.instance, equals(mockInfo));
      expect(AppInfoService.appName, 'MindFeed Editorial');
      expect(AppInfoService.version, '2.5.0');
      expect(AppInfoService.buildNumber, '42');
      expect(AppInfoService.versionWithBuild, '2.5.0+42');
      expect(AppInfoService.formattedStamp, 'v2.5.0+42');
    });

    test('init loads from platform channel via setMockInitialValues', () async {
      PackageInfo.setMockInitialValues(
        appName: 'MindFeed',
        packageName: 'mind.feed.pol4b',
        version: '3.1.4',
        buildNumber: '99',
        buildSignature: '',
      );

      await AppInfoService.init();

      expect(AppInfoService.isInitialized, isTrue);
      expect(AppInfoService.version, '3.1.4');
      expect(AppInfoService.buildNumber, '99');
      expect(AppInfoService.formattedStamp, 'v3.1.4+99');
    });
  });
}
