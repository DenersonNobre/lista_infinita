import 'dart:async';
import 'package:flutter/material.dart';

import '../domain/models/produto.dart';
import '../helpers/command.dart';
import '../helpers/result.dart';

import 'contracts/controller.dart';

class Controller extends IController {
  Controller(super.repository);

  int _currentPage = 0;
  final int _limit = 20;

  @override
  Future<void> init() async {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    fetchCommand = Command1((p) => _fetchAction(refresh: p));
    fetchCommand.addListener(_onFetchChanged);
    //...
    await fetchCommand.run(true);
    //...
  }

  Future<Result<List<Produto>, Exception>> _fetchAction({bool refresh = false}) async {
    isRefreshing = refresh;

    if (refresh) {
      repository.clear();
      items.clear();
      _currentPage = 0;
    }

    final result = await repository.read(
      page: ++_currentPage,
      limit: _limit,
    );

    return result;
  }

  void _onFetchChanged() {
    if (fetchCommand.result != null && fetchCommand.result!.isSuccess) {
      final newItems = fetchCommand.result!.valueOrNull ?? [];
      if (isRefreshing) {
        items = List<Produto>.from(newItems);
      } else {
        items.addAll(newItems);
      }
      isRefreshing = false;
    }
    notifyListeners();
  }

  void _scrollListener() {
    const threshold = 50.0;
    final currentScroll = scrollController.position.pixels;
    final maxScroll = scrollController.position.maxScrollExtent;
    if ((maxScroll - currentScroll) <= threshold && !fetchCommand.isRunning) {
      fetchCommand.run(false);
    }
  }
}
