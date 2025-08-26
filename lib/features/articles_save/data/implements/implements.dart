
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class Articles_saveRepositoryImp implements Articles_saveRepository{

        final Articles_saveRemoteDataSource remoteDataSource;
        Articles_saveRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    