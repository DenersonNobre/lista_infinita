import '../domain/contracts/datasource.dart';

class DataSource<T> extends IDataSource<T> {
  DataSource(super.factory);

  final _store = <T>[];

  @override
  void clear() => _store.clear();

  @override
  Future<List<T>> read({int page = 1, int limit = 20}) async {
    // Simular delay de I/O (para manter comportamento assíncrono)
    await Future.delayed(const Duration(milliseconds: 600));

    final startIndex = (page - 1) * limit;
    final newItems = List.generate(
      limit,
      (index) => factory(
        startIndex + index,
      ),
    );

    _store.addAll(newItems);

    return newItems;
  }
}
