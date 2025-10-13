import 'dart:async';
import 'package:flutter/material.dart';

import '../../domain/contracts/repository.dart';
import '../../domain/models/produto.dart';

abstract class IController with ChangeNotifier {
  final IRepository<Produto> repository;
  IController(this.repository);

  Future<void> init();

  late final ScrollController scrollController;

  final isLoading = ValueNotifier(false);

  bool isRefreshing = false;

  var items = <Produto>[];

  Future<void> fetchData({bool refresh = false});
}
