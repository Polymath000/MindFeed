import 'package:dio/dio.dart';

class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});

  factory ServerFailure.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          message:
              'Connection timed out. Please check your internet connection.',
        );

      case DioExceptionType.sendTimeout:
        return ServerFailure(
          message: 'Request took too long to send. Please try again.',
        );

      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          message: 'Server took too long to respond. Please try again later.',
        );

      case DioExceptionType.badCertificate:
        return ServerFailure(
          message: 'The server certificate is not trusted. Connection refused.',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final statusMessage =
            e.response?.statusMessage ?? 'Unexpected server response.';
        return ServerFailure(
          message: 'Server error ($statusCode): $statusMessage',
        );

      case DioExceptionType.cancel:
        return ServerFailure(
          message: 'The request was cancelled before completion.',
        );

      case DioExceptionType.connectionError:
        return ServerFailure(
          message:
              'Failed to connect to the server. Please check your internet connection.',
        );

      case DioExceptionType.unknown:
        if (e.message != null && e.message!.contains('SocketException')) {
          return ServerFailure(
            message: 'No internet connection. Please connect to a network.',
          );
        } else {
          return ServerFailure(
            message: 'An unexpected error occurred. Please try again.',
          );
        }
    }
  }
}
