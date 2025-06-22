import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/models/compra.dart';

class Acao {
  final String id;
  final String codigo;
  final double precoMedio;
  final int quantidade;
  double precoAtual;
  final List<Compra> historicoCompras;

  Acao({
    required this.id,
    required this.codigo,
    required this.precoMedio,
    required this.quantidade,
    required this.precoAtual,
    this.historicoCompras = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'precoMedio': precoMedio,
      'quantidade': quantidade,
      'precoAtual': precoAtual,
      'historicoCompras': historicoCompras.map((c) => c.toMap()).toList(),
    };
  }

  double get totalInvestido => precoMedio * quantidade;

  double get valorAtual => precoAtual * quantidade;

  double get lucroPrejuizo => valorAtual - totalInvestido;

  double get rentabilidadePercentual {
    if (totalInvestido == 0) return 0;
    return (lucroPrejuizo / totalInvestido) * 100;
  }

  factory Acao.fromMap(Map<String, dynamic> map, String id) {
    return Acao(
      id: id,
      codigo: map['codigo'] ?? '',
      precoMedio: (map['precoMedio'] ?? 0).toDouble(),
      quantidade: (map['quantidade'] ?? 0).toInt(),
      precoAtual: (map['precoAtual'] ?? 0).toDouble(),
      historicoCompras:
          (map['historicoCompras'] as List<dynamic>?)
              ?.map((item) => Compra.fromMap(item))
              .toList() ??
          [],
    );
  }

  factory Acao.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Acao.fromMap(data, doc.id);
  }

  Map<String, dynamic> toApi() {
    return {
      'symbol': codigo,
      'averagePrice': precoMedio,
      'amount': quantidade,
      'currentPrice': precoAtual,
    };
  }

  factory Acao.fromApi(Map<String, dynamic> map) {
    return Acao(
      id:
          map['id']?.toString() ??
          '', 
      codigo: map['symbol'] ?? '',
      precoMedio: (map['averagePrice'] ?? 0).toDouble(),
      quantidade: (map['amount'] ?? 0).toInt(),
      precoAtual: (map['currentPrice'] ?? 0).toDouble(),
    );
  }

  Acao atualizarPreco(double novoPreco) {
    return Acao(
      id: id,
      codigo: codigo,
      precoMedio: precoMedio,
      quantidade: quantidade,
      precoAtual: novoPreco,
    );
  }

  Acao copyWith({
    String? id,
    String? codigo,
    double? precoMedio,
    int? quantidade,
    double? precoAtual,
    List<Compra>? historicoCompras,
  }) {
    return Acao(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      precoMedio: precoMedio ?? this.precoMedio,
      quantidade: quantidade ?? this.quantidade,
      precoAtual: precoAtual ?? this.precoAtual,
      historicoCompras: historicoCompras ?? this.historicoCompras,
    );
  }
}
