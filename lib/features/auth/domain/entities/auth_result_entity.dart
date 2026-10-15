import 'package:equatable/equatable.dart';

class AuthResultEntity extends Equatable {
  final bool hasActiveSession;
  final String email;
  final String? accessToken;
  final String? userId;

  const AuthResultEntity({
    required this.hasActiveSession,
    required this.email,
    this.accessToken,
    this.userId,
  });

  @override
  List<Object?> get props => [hasActiveSession, email, accessToken, userId];
}
