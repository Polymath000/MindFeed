import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/core/networking/network_info.dart';

import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('dev.fluttercommunity.plus/connectivity');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return <String>['wifi'];
    });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await getIt.reset();
  });

  test(
    'service locator initializes NetworkInfo correctly without throwing',
    () async {
      setupServiceLocator();
      final networkInfo = getIt.get<NetworkInfoImpl>();
      expect(networkInfo, isNotNull);
      expect(await networkInfo.isConnected, isNotNull);
    },
  );
}
