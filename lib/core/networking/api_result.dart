import '../errors/failures.dart';

sealed class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      final FailureResult<T> result => failure(result.failure),
    };
  }
}

final class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

final class FailureResult<T> extends ApiResult<T> {
  final Failure failure;
  const FailureResult(this.failure);
}
