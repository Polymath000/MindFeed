
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class FavoritemoviesRepositoryImp implements FavoritemoviesRepository{

        final FavoritemoviesRemoteDataSource remoteDataSource;
        FavoritemoviesRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    