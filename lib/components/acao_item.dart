import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/acoes.dart';
import 'package:flutter_application_2/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/providers/acoes_provider.dart';

class AcaoItem extends StatelessWidget {
  final Acao acao;
  final bool isPortrait;
  final Function editarAcao;

  const AcaoItem(
    this.acao,
    this.editarAcao, {
    super.key,
    this.isPortrait = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        onPressed: () async {
          final acoesProvider = context.read<AcoesProvider>();
          final listaAcoes = acoesProvider.acoes ?? [];

          for (var acao in listaAcoes) {
            final provider = Provider.of<AcoesProvider>(context, listen: false);
            final novoPreco = await provider.getPrecoAtual(acao.codigo);
            if (novoPreco != null) {
              final novaAcao = acao.copyWith(precoAtual: novoPreco);
              await acoesProvider.update(novaAcao);
            }
          }
          await acoesProvider.getAll();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Preços atualizados com sucesso!')),
          );
        },
        icon: Icon(Icons.trending_up, color: Colors.green),
      ),
      title: Text(acao.codigo),
      subtitle: Text(
        'Qtd: ${acao.quantidade} | PM: R\$ ${acao.precoMedio.toStringAsFixed(2)} | Atual: R\$ ${acao.precoAtual.toStringAsFixed(2)}',
      ),
      trailing: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.ACAO, arguments: acao);
        },
        icon: Icon(Icons.remove_red_eye),
      ),
      isThreeLine: !isPortrait,
    );
  }
}
