import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool>? get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker? dataConnectionChecker;
  NetworkInfoImpl([this.dataConnectionChecker]);

  @override
  Future<bool>? get isConnected async {
    if (kIsWeb) {
      return true;
    }
    if (dataConnectionChecker != null) {
      return await dataConnectionChecker!.hasConnection;
    }
    return true;
  }
}
