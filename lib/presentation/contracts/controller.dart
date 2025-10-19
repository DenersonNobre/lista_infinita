import 'dart:async';
import 'package:flutter/material.dart';

import '../../domain/contracts/repository.dart';
import '../../domain/models/produto.dart';
import '../../helpers/command.dart';

abstract class IController with ChangeNotifier {
  final IRepository<Produto> repository;
  IController(this.repository) {
    init();
  }

  var items = <Produto>[];
  var isRefreshing = false;

  late final ScrollController scrollController;
  late final Command1<List<Produto>, bool> fetchCommand;

  @override
  void dispose() {
    scrollController.dispose();
    fetchCommand.dispose();
    super.dispose();
  }

  Future<void> init();
}
