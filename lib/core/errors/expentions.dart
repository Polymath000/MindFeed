import 'package:dio/dio.dart';
import 'package:mind_feed/core/errors/error_model.dart' show ErrorModel;

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!CacheExeption
class CacheExeption implements Exception {
  final String errorMessage;
  CacheExeption({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

ErrorModel _buildErrorModel(DioException e, {required String fallbackMessage}) {
  final responseData = e.response?.data;
  if (responseData != null) {
    return ErrorModel.fromJson(responseData);
  }

  return ErrorModel(
    status: e.response?.statusCode ?? 0,
    errorMessage: e.message ?? fallbackMessage,
  );
}

Never handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(
        _buildErrorModel(e, fallbackMessage: 'Connection error'),
      );
    case DioExceptionType.badCertificate:
      throw BadCertificateException(
        _buildErrorModel(e, fallbackMessage: 'Bad certificate'),
      );
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(
        _buildErrorModel(e, fallbackMessage: 'Connection timeout'),
      );

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(
        _buildErrorModel(e, fallbackMessage: 'Receive timeout'),
      );

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(
        _buildErrorModel(e, fallbackMessage: 'Send timeout'),
      );

    case DioExceptionType.badResponse:
      final errorModel = _buildErrorModel(e, fallbackMessage: 'Bad response');
      switch (e.response?.statusCode) {
        case 400: // Bad request

          throw BadResponseException(errorModel);

        case 401: //unauthorized
          throw UnauthorizedException(errorModel);

        case 403: //forbidden
          throw ForbiddenException(errorModel);

        case 404: //not found
          throw NotFoundException(errorModel);

        case 409: //cofficient

          throw CofficientException(errorModel);

        case 504: // Bad request

          throw BadResponseException(
            ErrorModel(
              status: 504,
              errorMessage: e.response?.data?.toString() ?? 'Gateway timeout',
            ),
          );
        default:
          throw BadResponseException(errorModel);
      }

    case DioExceptionType.cancel:
      throw CancelException(
        ErrorModel(errorMessage: e.toString(), status: 500),
      );

    case DioExceptionType.unknown:
      throw UnknownException(
        ErrorModel(errorMessage: e.toString(), status: 500),
      );
  }

  throw UnknownException(ErrorModel(errorMessage: e.toString(), status: 500));
}
