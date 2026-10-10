import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SupabaseInterceptor extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Only intercept and print in Debug mode
    if (kDebugMode) {
      debugPrint('🚀 [Supabase Request] ${request.method} ${request.url}');
    }

    final response = await _inner.send(request);

    if (kDebugMode) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('✅ [Supabase Success] ${response.statusCode} ${request.url}');
      } else {
        debugPrint('❌ [Supabase Error] ${response.statusCode} ${request.url}');
      }
    }

    return response;
  }
}
