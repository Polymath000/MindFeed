
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class Downloaded_articles_viewRepositoryImp implements Downloaded_articles_viewRepository{

        final Downloaded_articles_viewRemoteDataSource remoteDataSource;
        Downloaded_articles_viewRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    