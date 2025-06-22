class Compra {
  final double preco;
  final int quantidade;

  Compra({required this.preco, required this.quantidade});

  Map<String, dynamic> toMap() {
    return {
      'preco': preco,
      'quantidade': quantidade,
    };
  }

  factory Compra.fromMap(Map<String, dynamic> map) {
    return Compra(
      preco: (map['preco'] ?? 0).toDouble(),
      quantidade: (map['quantidade'] ?? 0).toInt(),
    );
  }
}
