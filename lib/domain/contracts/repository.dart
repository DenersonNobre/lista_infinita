import 'datasource.dart';

abstract class IRepository<T> {
  final IDataSource<T> dts;
  IRepository(this.dts);

  void clear();
  Future<List<T>> read({
    int page = 1,
    int limit = 20,
  });
}
