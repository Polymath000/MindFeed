
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class AuthorRepositoryImp implements AuthorRepository{

        final AuthorRemoteDataSource remoteDataSource;
        AuthorRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    