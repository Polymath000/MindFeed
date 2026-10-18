import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/articles/domain/entities/category_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';

class GetCategoriesUseCase {
  final ArticlesRepository repo;

  GetCategoriesUseCase(this.repo);

  Future<ApiResult<List<CategoryEntity>>> call() {
    return repo.getCategories();
  }
}
