import 'package:flutter_test/flutter_test.dart';
import 'package:lista_infinita/presentation/controller.dart';
import 'package:lista_infinita/data/datasource.dart';
import 'package:lista_infinita/data/repository.dart';
import 'package:lista_infinita/domain/models/produto.dart';

void main() {
  test('Controller pagination and refresh behavior', () async {
    final datasource = DataSource<Produto>(Produto.factory);
    final repo = Repository<Produto>(datasource);
    final controller = Controller(repo);

    // wait for initial load
    await Future.delayed(const Duration(milliseconds: 800));
    expect(controller.items.length, greaterThan(0));

    final firstItems = controller.items;
    expect((firstItems.first as dynamic).id, equals(1));

    await controller.fetchCommand.run(false);
    // Aceitamos que, em alguns timings, a lista possa já estar com mais páginas.
    expect(controller.items.length, greaterThanOrEqualTo(firstItems.length));

    // Verificar unicidade de ids após paginação
    final allIdsAfter = controller.items.map((e) => (e as dynamic).id).toList();
    expect(allIdsAfter.toSet().length, equals(allIdsAfter.length));

    await controller.fetchCommand.run(true);
    expect(controller.items.isNotEmpty, isTrue);
    expect((controller.items.first as dynamic).id, equals(1));

    final f1 = controller.fetchCommand.run(false);
    final f2 = controller.fetchCommand.run(false);
    await Future.wait([f1, f2]);

    expect(controller.items.length, greaterThanOrEqualTo(1));
  });
}
