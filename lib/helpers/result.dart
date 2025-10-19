/// Representa um resultado que pode ser sucesso [S] ou erro [E].
sealed class Result<S, E extends Exception> {
  const Result();
}

/// Resultado de sucesso contendo um valor do tipo [S]
final class Success<S, E extends Exception> extends Result<S, E> {
  const Success(this.value);
  final S value;
}

/// Resultado de erro contendo uma exceção do tipo [E]
final class Failure<S, E extends Exception> extends Result<S, E> {
  const Failure(this.error);
  final E error;
}

/// Extension para manipular o resultado de forma simples.
extension ResultExtension<S, E extends Exception> on Result<S, E> {
  /// Retorna valor de sucesso ou executa função de erro.
  S fold(S Function(E error) onError) => switch (this) {
    Success(:final value) => value,
    Failure(:final error) => onError(error),
  };

  /// Verifica se é sucesso.
  bool get isSuccess => this is Success<S, E>;

  /// Verifica se é falha.
  bool get isFailure => this is Failure<S, E>;

  /// Retorna valor de sucesso ou null se for falha.
  S? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Failure() => null,
  };
}
