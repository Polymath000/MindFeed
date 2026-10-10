import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/network/network_info.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';

void main() {
  tearDown(() async {
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
