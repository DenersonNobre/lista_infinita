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
    final backgroundColor = Theme.of(context).colorScheme.inversePrimary;

    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchCommand.run(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(title),
        ),
        body: AnimatedBuilder(
          animation: controller.fetchCommand,
          builder: (context, snapshot) {
            // Determina o estado do loading
            final isLoading = controller.fetchCommand.isRunning && !controller.isRefreshing;
            // Determina o estado do erro
            final isError = controller.fetchCommand.isFailure;

            // Renderiza a lista
            return Stack(
              children: [
                ListView.builder(
                  itemCount: controller.items.length,
                  controller: controller.scrollController,
                  itemBuilder: (context, index) {
                    final produto = controller.items[index];
                    return ListTile(
                      key: ValueKey(produto.id),
                      leading: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircleAvatar(
                          child: Text(produto.id.toString()),
                        ),
                      ),
                      title: Text(produto.nome),
                      subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
                    );
                  },
                ),
                Visibility(
                  visible: isLoading && !isError,
                  child: LoadingIndicatorProgress(),
                ),
                Visibility(
                  visible: isError && !isLoading,
                  child: LoadingIndicatorError(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LoadingIndicatorError extends StatelessWidget {
  const LoadingIndicatorError({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (MediaQuery.of(context).size.width / 2) - 60,
      bottom: 24,
      height: 40,
      child: SizedBox(
        width: 120,
        height: 40,
        child: CircleAvatar(
          backgroundColor: Colors.redAccent,
          child: const Text(
            'Erro ao carregar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingIndicatorProgress extends StatelessWidget {
  const LoadingIndicatorProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
    );
  }
}
