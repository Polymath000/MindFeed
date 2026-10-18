import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/tag_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class GetFixedTagsUseCase {
  final ArticlesRepository repo;

  GetFixedTagsUseCase(this.repo);

  Future<ApiResult<List<TagEntity>>> call() {
    return repo.getFixedTags();
  }
}
