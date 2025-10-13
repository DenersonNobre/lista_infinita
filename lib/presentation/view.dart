import 'package:flutter/material.dart';

import 'contracts/controller.dart';

class View extends StatelessWidget {
  final String title;
  final IController controller;
  const View({
    super.key,
    required this.title,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchData(refresh: true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          title: Text(title),
        ),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, snapshot) {
            return Stack(
              children: [
                ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final produto = controller.items[index];
                    return ListTile(
                      key: ValueKey(produto.id),
                      title: Text(produto.nome),
                    );
                  },
                ),
                loadingIndicadorProgress(),
              ],
            );
          },
        ),
      ),
    );
  }

  loadingIndicadorProgress() {
    return ValueListenableBuilder(
      valueListenable: controller.isLoading,
      builder: (context, isLoading, _) {
        return (isLoading && !controller.isRefreshing)
            ? Positioned(
                left: (MediaQuery.of(context).size.width / 2) - 20,
                bottom: 24,
                height: 40,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircleAvatar(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
