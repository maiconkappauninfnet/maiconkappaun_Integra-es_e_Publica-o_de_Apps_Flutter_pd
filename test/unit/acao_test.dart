import 'package:flutter_application_2/models/acoes.dart';
import 'package:flutter_application_2/models/compra.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testes do model Acao', () {
    final compras = [
      Compra(preco: 20.0, quantidade: 5),
      Compra(preco: 30.0, quantidade: 5),
    ];

    final acao = Acao(
      id: '1',
      codigo: 'PETR4',
      precoMedio: 25.0,
      quantidade: 10,
      precoAtual: 30.0,
      historicoCompras: compras,
    );

    test('totalInvestido deve retornar precoMedio * quantidade', () {
      expect(acao.totalInvestido, 250.0);
    });

    test('valorAtual deve retornar precoAtual * quantidade', () {
      expect(acao.valorAtual, 300.0);
    });

    test('lucroPrejuizo deve retornar valorAtual - totalInvestido', () {
      expect(acao.lucroPrejuizo, 50.0);
    });

    test('rentabilidadePercentual deve calcular corretamente', () {
      expect(acao.rentabilidadePercentual, closeTo(20.0, 0.001));
    });

    test('copyWith deve modificar somente os campos especificados', () {
      final novaAcao = acao.copyWith(precoAtual: 35.0, quantidade: 15);

      expect(novaAcao.id, acao.id);
      expect(novaAcao.precoAtual, 35.0);
      expect(novaAcao.quantidade, 15);
      expect(novaAcao.precoMedio, acao.precoMedio);
      expect(novaAcao.historicoCompras, acao.historicoCompras);
    });

    test(
      'atualizarPreco deve criar nova instância com precoAtual atualizado',
      () {
        final atualizada = acao.atualizarPreco(32.5);

        expect(atualizada.precoAtual, 32.5);
        expect(atualizada.id, acao.id);
        expect(atualizada.codigo, acao.codigo);
      },
    );

    test('fromMap e toMap devem ser inversos', () {
      final map = acao.toMap();
      final acaoFromMap = Acao.fromMap(map, acao.id);

      expect(acaoFromMap.id, acao.id);
      expect(acaoFromMap.codigo, acao.codigo);
      expect(acaoFromMap.precoMedio, acao.precoMedio);
      expect(acaoFromMap.quantidade, acao.quantidade);
      expect(acaoFromMap.precoAtual, acao.precoAtual);
      expect(acaoFromMap.historicoCompras.length, acao.historicoCompras.length);
      expect(
        acaoFromMap.historicoCompras[0].preco,
        acao.historicoCompras[0].preco,
      );
    });

    test('fromApi deve criar instância corretamente', () {
      final apiMap = {
        'id': '999',
        'symbol': 'ABCD',
        'averagePrice': 40.0,
        'amount': 20,
        'currentPrice': 42.0,
      };

      final acaoApi = Acao.fromApi(apiMap);

      expect(acaoApi.id, '999');
      expect(acaoApi.codigo, 'ABCD');
      expect(acaoApi.precoMedio, 40.0);
      expect(acaoApi.quantidade, 20);
      expect(acaoApi.precoAtual, 42.0);
    });
  });
}
