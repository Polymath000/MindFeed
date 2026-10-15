import 'package:supabase_flutter/supabase_flutter.dart';
import '../errors/failures.dart';
import '../errors/exceptions.dart';

class ApiErrorHandler {
  final String message;
  final String? code;

  ApiErrorHandler._(this.message, this.code);

  static ApiErrorHandler handle(Object error) {
    if (error is NoInternetException) {
      return ApiErrorHandler._('No internet connection. Please check your network and try again.', 'no-internet');
    }
    
    if (error is AuthException) {
      final msg = error.message.toLowerCase();
      
      if (msg.contains('invalid login credentials')) {
        return ApiErrorHandler._('No user found or wrong password provided.', error.statusCode?.toString());
      } else if (msg.contains('already registered') || msg.contains('already exists')) {
        return ApiErrorHandler._('The account already exists for that email.', error.statusCode?.toString());
      } else if (msg.contains('invalid format') || msg.contains('invalid email')) {
        return ApiErrorHandler._('The email address is badly formatted.', error.statusCode?.toString());
      } else if (msg.contains('password should be at least') || msg.contains('weak')) {
        return ApiErrorHandler._('The password provided is too weak.', error.statusCode?.toString());
      } else if (msg.contains('network') || msg.contains('fetch')) {
        return ApiErrorHandler._('Network error. Please check your internet connection.', error.statusCode?.toString());
      } else {
        return ApiErrorHandler._(error.message, error.statusCode?.toString());
      }
    } else if (error is PostgrestException) {
      switch (error.code) {
        case '42501': // Postgres Insufficient Privilege (Row Level Security)
          return ApiErrorHandler._('You do not have permission to execute this action.', error.code);
        case '23505': // Postgres Unique Violation
          return ApiErrorHandler._('This record already exists.', error.code);
        case '53300': // Postgres Too Many Connections
          return ApiErrorHandler._('The service is currently unavailable. Try again later.', error.code);
        default:
          return ApiErrorHandler._(error.message, error.code);
      }
    }

    return ApiErrorHandler._('An unexpected error occurred.', null);
  }

  Failure toFailure() {
    return ServerFailure(message);
  }
}
