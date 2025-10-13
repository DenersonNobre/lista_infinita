import 'dart:math';

abstract class Model {
  Map<String, dynamic> toMap();
}

class Produto extends Model {
  final int id;
  final String nome;
  final double preco;

  Produto({
    required this.id,
    required this.nome,
    required this.preco,
  });

  static Produto factory(int index) {
    final random = Random();
    final valor = (random.nextDouble() * 100).roundToDouble();
    return Produto(
      id: index + 1,
      nome: 'Produto Aleatório ${index + 1}',
      preco: valor,
    );
  }

  @override
  toMap() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
    };
  }
}
