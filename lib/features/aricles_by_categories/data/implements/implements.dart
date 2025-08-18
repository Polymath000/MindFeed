
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class Aricles_by_categoriesRepositoryImp implements Aricles_by_categoriesRepository{

        final Aricles_by_categoriesRemoteDataSource remoteDataSource;
        Aricles_by_categoriesRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    