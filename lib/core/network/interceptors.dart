import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger
      ..e('${options.method} request ==> $requestPath') //Error log
      ..d(
        'Error type: ${err.error} \n '
        'Error message: ${err.message}',
      ); //Debug log
    handler.next(err); //Continue with the Error
  }

  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request ==> $requestPath'); //Info log
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(
    final Response response,
    final ResponseInterceptorHandler handler,
  ) {
    logger.d(
      'STATUSCODE: ${response.statusCode} \n '
      'STATUSMESSAGE: ${response.statusMessage} \n'
      'HEADERS: ${response.headers} \n'
      'Data: ${response.data}',
    ); // Debug log
    handler.next(response); // continue with the Response
  }
}
