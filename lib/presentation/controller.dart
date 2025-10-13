import 'dart:async';
import 'package:flutter/material.dart';

import '../domain/models/produto.dart';

import 'contracts/controller.dart';

class Controller extends IController {
  Controller(super.repository) {
    init();
  }

  @override
  init() async {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    await fetchData();
  }

  @override
  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void>? _ongoingFetch;
  int _currentPage = 0;
  final int _limit = 20;

  @override
  fetchData({bool refresh = false}) async {
    if (_ongoingFetch != null) {
      await _ongoingFetch;
      return;
    }

    final completer = Completer<void>();
    _ongoingFetch = completer.future;

    isRefreshing = refresh;

    if (isRefreshing) {
      repository.clear();
      items.clear();
      _currentPage = 0;
    }

    isLoading.value = true;
    notifyListeners();

    final newItems = await repository.read(
      page: ++_currentPage,
      limit: _limit,
    );

    if (isRefreshing) {
      items = List<Produto>.from(newItems);
    } else {
      items.addAll(newItems);
    }

    isRefreshing = false;
    isLoading.value = false;
    notifyListeners();

    completer.complete();

    _ongoingFetch = null;
  }

  _scrollListener() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    const threshold = 50.0; // pixels antes do fim para carregar mais
    if ((maxScroll - currentScroll) <= threshold && !isLoading.value) {
      //...
      fetchData();
      //...
    }
  }
}
