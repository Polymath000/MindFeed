import 'dart:typed_data';

import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class UploadProfileAvatarUseCase {
  final ProfileRepository repository;

  const UploadProfileAvatarUseCase(this.repository);

  Future<ApiResult<String>> call({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousAvatarUrl,
  }) {
    return repository.uploadAvatar(
      userId: userId,
      bytes: bytes,
      fileExtension: fileExtension,
      previousAvatarUrl: previousAvatarUrl,
    );
  }
}
