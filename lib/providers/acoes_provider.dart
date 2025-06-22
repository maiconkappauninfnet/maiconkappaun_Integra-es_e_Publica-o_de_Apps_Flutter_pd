import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/acoes.dart';
import 'package:flutter_application_2/models/compra.dart';
import 'package:flutter_application_2/services/AcoesService.dart';
import 'package:flutter_application_2/services/BrapiService.dart';

class CarteiraAnalise {
  final double totalInvestido;
  final double valorAtual;
  final double lucroTotal;
  final double rentabilidadePercentual;

  CarteiraAnalise({
    required this.totalInvestido,
    required this.valorAtual,
    required this.lucroTotal,
    required this.rentabilidadePercentual,
  });
}

class AcoesProvider with ChangeNotifier {
  final AcoesService _acoesService;
  Acao? _acaoSelecionada;
  List<Acao>? _acoes = [];
  bool _isLoading = false;
  String? _error;

  AcoesProvider(this._acoesService);

  Acao? get acaoSelecionada => _acaoSelecionada;
  List<Acao>? get acoes => _acoes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CarteiraAnalise get analiseGeral {
    double totalInvestido = 0;
    double valorAtual = 0;

    if (_acoes != null) {
      for (var acao in _acoes!) {
        double investidoNaAcao = acao.historicoCompras.fold(
          0,
          (sum, compra) => sum + (compra.preco * compra.quantidade),
        );

        totalInvestido += investidoNaAcao;
        valorAtual += acao.valorAtual;
      }
    }

    double lucro = valorAtual - totalInvestido;
    double rentabilidade =
        totalInvestido > 0 ? (lucro / totalInvestido) * 100 : 0;

    return CarteiraAnalise(
      totalInvestido: totalInvestido,
      valorAtual: valorAtual,
      lucroTotal: lucro,
      rentabilidadePercentual: rentabilidade,
    );
  }

  Future<void> getAll() async {
    _error = null;
    _initIsLoading();
    try {
      _acoes = await _acoesService.getAll();
    } catch (e) {
      _error = e.toString();
      _acoes = [];
    } finally {
      _initIsLoading(false);
    }
  }

  Future<void> add(Acao acao) async {
    _initIsLoading();
    try {
      bool existe = _acoes!.any(
        (a) => a.codigo.toUpperCase() == acao.codigo.toUpperCase(),
      );

      if (existe) {
        throw Exception(
          'Ação com código ${acao.codigo} já existe na sua lista.',
        );
      }

      final historicoInicial = [
        Compra(preco: acao.precoMedio, quantidade: acao.quantidade),
      ];

      final novaAcao = acao.copyWith(historicoCompras: historicoInicial);

      String id = await _acoesService.addAcao(novaAcao);
      _acoes?.add(novaAcao.copyWith(id: id));
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _initIsLoading(false);
    }
  }

  Future<void> comprarMais(Acao acao, int qtdCompra) async {
    final precoAtual = await getPrecoAtual(acao.codigo);

    if (precoAtual == null) {
      throw Exception(
        'Não foi possível buscar o preço atual para ${acao.codigo}',
      );
    }

    final novaQuantidade = acao.quantidade + qtdCompra;
    final novoTotalInvestido =
        (acao.precoMedio * acao.quantidade) + (precoAtual * qtdCompra);
    final novoPrecoMedio = novoTotalInvestido / novaQuantidade;

    final novoHistorico = List<Compra>.from(acao.historicoCompras)
      ..add(Compra(preco: precoAtual, quantidade: qtdCompra));

    final novaAcao = acao.copyWith(
      quantidade: novaQuantidade,
      precoMedio: novoPrecoMedio,
      historicoCompras: novoHistorico,
    );

    await _acoesService.updateAcao(novaAcao);
    await getAll();
  }

  Future<void> getById(String id) async {
    _error = null;
    _initIsLoading();
    try {
      _acaoSelecionada = await _acoesService.getAcao(id);
    } catch (e) {
      _error = e.toString();
      _acaoSelecionada = null;
    } finally {
      _initIsLoading(false);
    }
  }

  Future<void> update(Acao acao) async {
    _error = null;
    _initIsLoading();
    try {
      await _acoesService.updateAcao(acao);
      if (_acoes != null) {
        final index = _acoes!.indexWhere((a) => a.id == acao.id);
        if (index != -1) {
          _acoes![index] = acao;
          notifyListeners();
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _initIsLoading(false);
    }
  }

  Future<double?> getPrecoAtual(String codigo) async {
    return await BrapiService.buscarPrecoAtual(codigo);
  }

  Future<bool> delete(Acao acao) async {
    bool result = false;
    _error = null;
    _initIsLoading();
    try {
      await _acoesService.deleteAcao(acao.id);
      _acoes?.removeWhere((a) => a.id == acao.id);
      notifyListeners();
      result = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _initIsLoading(false);
    }
    return result;
  }

  void _initIsLoading([bool value = true]) {
    _isLoading = value;
    notifyListeners();
  }
}
