abstract class IDataSource<T> {
  final T Function(int index) factory;
  IDataSource(this.factory);

  void clear();

  Future<List<T>> read({
    int page = 1,
    int limit = 20,
  });
}
