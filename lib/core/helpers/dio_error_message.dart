import 'package:dio/dio.dart';

String mapDioErrorToMessage(final DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Oops! The connection took too long. '
          'Please check your internet and try again.';
    case DioExceptionType.badResponse:
      return 'Maybe your password or your email is not correct ';
    case DioExceptionType.cancel:
      return 'No worries, your request was cancelled.';
    case DioExceptionType.unknown:
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return 'Oops! Something went wrong with the network. '
          'Please check your connection and try again.';
  }
}
