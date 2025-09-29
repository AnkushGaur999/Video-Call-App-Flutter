sealed class DataState<T> {
  final T? data;
  final String? error;

  DataState(this.data, this.error);
}

class DataSuccess<T> extends DataState<T> {
  DataSuccess({required T data}) : super(data, null);
}

class DataError<T> extends DataState<T> {
  DataError({required String error}) : super(null, error);
}
