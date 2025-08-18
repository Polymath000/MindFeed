
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class SearchRepositoryImp implements SearchRepository{

        final SearchRemoteDataSource remoteDataSource;
        SearchRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    