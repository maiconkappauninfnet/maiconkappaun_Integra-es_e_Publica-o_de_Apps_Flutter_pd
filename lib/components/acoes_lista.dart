import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/acao_item.dart';
import 'package:flutter_application_2/models/acoes.dart';

class AcoesLista extends StatelessWidget {
  final double height;
  final bool isPortrait;
  final List<Acao> listaAcoes;
  final Function editarAcao;

  const AcoesLista(
    this.listaAcoes,
    this.editarAcao,
    this.height, {
    super.key,
    this.isPortrait = true,
  });

  Widget gerarItemLista(int index, bool isPortrait) {
    Acao acao = listaAcoes[index];
    return AcaoItem(acao, editarAcao, isPortrait: isPortrait);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.6,
      child: ListView.builder(
        itemCount: listaAcoes.length,
        itemBuilder: (context, index) {
          return gerarItemLista(index, isPortrait);
        },
      ),
    );
  }
}
