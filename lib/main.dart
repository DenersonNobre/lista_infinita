import 'package:flutter/material.dart' hide View;

import 'data/datasource.dart';
import 'data/repository.dart';
import 'domain/contracts/datasource.dart';
import 'domain/contracts/repository.dart';
import 'domain/models/produto.dart';
import 'presentation/contracts/controller.dart';
import 'presentation/controller.dart';
import 'presentation/view.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  String get title => 'Demo Lista Infinita';
  IDataSource<Produto> get datasource => DataSource(Produto.factory);
  IRepository<Produto> get repository => Repository(datasource);
  IController get controller => Controller(repository);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista Infinita',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: View(
        title: title,
        controller: controller,
      ),
    );
  }
}
