import 'dart:typed_data';

import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/networking/api_result.dart';

class UploadArticleCoverImageUseCase {
  final ArticlesRepository repository;
  const UploadArticleCoverImageUseCase(this.repository);

  Future<ApiResult<String>> call({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousCoverUrl,
  }) {
    return repository.uploadArticleCoverImage(
      userId: userId,
      bytes: bytes,
      fileExtension: fileExtension,
      previousCoverUrl: previousCoverUrl,
    );
  }
}
