import '../domain/contracts/repository.dart';
import '../helpers/result.dart';

class Repository<T> extends IRepository<T> {
  Repository(super.dts);

  @override
  void clear() => dts.clear();

  @override
  read({page = 1, limit = 20}) async {
    try {
      return Success(await dts.read(page: page, limit: limit));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
