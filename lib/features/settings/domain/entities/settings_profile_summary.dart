import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';

class SettingsProfileSummary {
  final String displayName;
  final String userEmail;
  final String? avatarUrl;
  final UserEntity? userEntity;

  const SettingsProfileSummary({
    this.displayName = '',
    this.userEmail = '',
    this.avatarUrl,
    this.userEntity,
  });

  SettingsProfileSummary copyWith({
    String? displayName,
    String? userEmail,
    String? avatarUrl,
    UserEntity? userEntity,
  }) {
    return SettingsProfileSummary(
      displayName: displayName ?? this.displayName,
      userEmail: userEmail ?? this.userEmail,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userEntity: userEntity ?? this.userEntity,
    );
  }
}
