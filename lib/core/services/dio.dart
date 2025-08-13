import 'package:dio/dio.dart';
import 'package:mind_feed/core/constants/end_ponits.dart';
import 'package:mind_feed/core/network/interceptors.dart';

Dio dio() {
  var dio = Dio()..interceptors.addAll([LoggerInterceptor()]);
  dio.options.baseUrl = EndPoint.apiUrl;
  dio.options.headers['accept'] = 'application/json';
  return dio;
}
