import '../domain/contracts/repository.dart';

class Repository<T> extends IRepository<T> {
  Repository(super.dts);

  @override
  void clear() {
    dts.clear();
  }

  @override
  read({page = 1, limit = 20}) async {
    return await dts.read(page: page, limit: limit);
  }
}
