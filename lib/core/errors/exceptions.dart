class ServerException implements Exception {}

class NoInternetException implements Exception {}
class CacheException implements Exception { final String? errorMessage; CacheException({this.errorMessage}); }
