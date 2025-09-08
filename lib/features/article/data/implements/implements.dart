
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class ArticleRepositoryImp implements ArticleRepository{

        final ArticleRemoteDataSource remoteDataSource;
        ArticleRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    