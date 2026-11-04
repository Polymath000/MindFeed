import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:mind_feed/core/services/app_info_service.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_archive_section.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_footer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    AppInfoService.reset();
  });

  tearDown(() {
    AppInfoService.reset();
  });

  group('SettingsFooter Widget', () {
    testWidgets('renders default dynamic version stamp and tagline', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsFooter(),
          ),
        ),
      );

      expect(
        find.text('MINDFEED v1.0.0+1 · VERIFIED JOURNALISM'),
        findsOneWidget,
      );
      expect(
        find.text('Built for thoughtful and uninterrupted reading'),
        findsOneWidget,
      );
    });

    testWidgets('renders custom dynamic version stamp from AppInfoService', (
      tester,
    ) async {
      AppInfoService.setMockInstance(
        PackageInfo(
          appName: 'MindFeed',
          packageName: 'mind.feed.pol4b',
          version: '2.4.1',
          buildNumber: '15',
          buildSignature: '',
          installerStore: null,
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsFooter(),
          ),
        ),
      );

      expect(
        find.text('MINDFEED v2.4.1+15 · VERIFIED JOURNALISM'),
        findsOneWidget,
      );
    });

    testWidgets('renders inside SettingsArchiveSection', (tester) async {
      AppInfoService.setMockInstance(
        PackageInfo(
          appName: 'MindFeed',
          packageName: 'mind.feed.pol4b',
          version: '1.2.0',
          buildNumber: '3',
          buildSignature: '',
          installerStore: null,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SettingsArchiveSection(
                cachedMegabytes: 5.4,
                onClearCache: () {},
                userEmail: 'reader@mindfeed.org',
                onSignOut: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SettingsFooter), findsOneWidget);
      expect(
        find.text('MINDFEED v1.2.0+3 · VERIFIED JOURNALISM'),
        findsOneWidget,
      );
      expect(
        find.text('Built for thoughtful and uninterrupted reading'),
        findsOneWidget,
      );
    });
  });
}
