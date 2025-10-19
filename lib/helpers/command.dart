import 'package:flutter/material.dart';

import 'result.dart';

/// Função assíncrona sem parâmetros.
typedef CommandAction0<T> = Future<Result<T, Exception>> Function();

/// Função assíncrona com parâmetro.
typedef CommandAction1<T, P> = Future<Result<T, Exception>> Function(P params);

/// Classe base para comandos assíncronos.
/// Controla execução e armazena resultado.
abstract class Command<T> with ChangeNotifier {
  Result<T, Exception>? _result;
  bool _isRunning = false;

  /// Último resultado do comando.
  Result<T, Exception>? get result => _result;

  /// Indica se está executando.
  bool get isRunning => _isRunning;

  /// Indica se o último resultado foi sucesso.
  bool get isSuccess => _result?.isSuccess ?? false;

  /// Indica se o último resultado foi erro.
  bool get isFailure => _result?.isFailure ?? false;

  /// Executa a ação, controlando estado de execução.
  Future<void> _execute(Future<Result<T, Exception>> Function() action) async {
    if (_isRunning) return;

    _result = null;
    _isRunning = true;

    notifyListeners();

    try {
      _result = await action();
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }
}

/// Comando sem parâmetros.
class Command0<T> extends Command<T> {
  final CommandAction0<T> action;
  Command0(this.action);

  /// Executa o comando.
  Future<void> run() async {
    await _execute(action);
  }
}

/// Comando com parâmetro.
class Command1<T, P> extends Command<T> {
  final CommandAction1<T, P> action;
  Command1(this.action);

  /// Executa o comando com parâmetro.
  Future<void> run(P params) async {
    await _execute(() => action(params));
  }
}
