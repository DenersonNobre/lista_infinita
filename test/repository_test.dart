import 'package:flutter_test/flutter_test.dart';
import 'package:lista_infinita/data/datasource.dart';
import 'package:lista_infinita/data/repository.dart';
import 'package:lista_infinita/helpers/result.dart';

class FakeModel {
  final int id;
  FakeModel(this.id);
}

void main() {
  test('Repository.read returns new items and delegates to datasource', () async {
    final datasource = DataSource<FakeModel>((i) => FakeModel(i));
    final repo = Repository<FakeModel>(datasource);

    final page1 = await repo.read(page: 1, limit: 3);
    expect((page1 as Success).value.length, 3);
    expect((page1 as Success).value[0].id, 0);

    final page2 = await repo.read(page: 2, limit: 3);
    expect((page2 as Success).value.length, 3);
    expect((page2 as Success).value[0].id, 3);
  });
}
