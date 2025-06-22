import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/acoes.dart';
import 'package:flutter_application_2/providers/acoes_provider.dart';
import 'package:provider/provider.dart';

class AcaoPage extends StatefulWidget {
  const AcaoPage({Key? key}) : super(key: key);

  @override
  State<AcaoPage> createState() => _AcaoPageState();
}

class _AcaoPageState extends State<AcaoPage> {
  Acao? acao;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (acao == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Acao) {
        acao = args;
        final provider = Provider.of<AcoesProvider>(context, listen: false);
        provider.getById(acao!.id).then((_) {
          setState(() {
            acao = provider.acaoSelecionada;
          });
        });
      }
    }
  }

  Future<void> _abrirDialogComprarMais() async {
  final quantidadeController = TextEditingController();
  double? precoAtual;
  double totalCompra = 0;

  final provider = Provider.of<AcoesProvider>(context, listen: false);

  precoAtual = await provider.getPrecoAtual(acao!.codigo);

  if (precoAtual == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao buscar o preço atual da ação')),
    );
    return;
  }

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void atualizarTotal() {
            final qtd = int.tryParse(quantidadeController.text) ?? 0;
            setState(() {
              totalCompra = precoAtual! * qtd;
            });
          }

          return AlertDialog(
            title: const Text('Comprar mais ações'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Preço atual',
                  ),
                  controller: TextEditingController(
                      text: precoAtual?.toStringAsFixed(2)),
                  enabled: false,
                ),
                TextField(
                  controller: quantidadeController,
                  decoration: const InputDecoration(labelText: 'Quantidade'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => atualizarTotal(),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total da compra: R\$ ${totalCompra.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final quantidade =
                      int.tryParse(quantidadeController.text.trim()) ?? 0;

                  if (quantidade > 0) {
                    try {
                      await provider.comprarMais(acao!, quantidade);
                      await provider.getById(acao!.id);
                      setState(() {
                        acao = provider.acaoSelecionada;
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro: ${e.toString()}')),
                      );
                    }
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    if (acao == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Carregando ação...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(acao!.codigo),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final provider = Provider.of<AcoesProvider>(
                context,
                listen: false,
              );
              bool deletado = await provider.delete(acao!);
              if (deletado) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ação removida')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao deletar ação')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Código: ${acao!.codigo}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Quantidade: ${acao!.quantidade}'),
              Text('Preço Médio: R\$ ${acao!.precoMedio.toStringAsFixed(2)}'),
              Text('Preço Atual: R\$ ${acao!.precoAtual.toStringAsFixed(2)}'),
              Text(
                'Total Investido: R\$ ${acao!.totalInvestido.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 16),
              const Text(
                'Histórico de Compras:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              if (acao!.historicoCompras.isEmpty)
                const Text('Nenhuma compra registrada ainda.')
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: acao!.historicoCompras.length,
                  itemBuilder: (context, index) {
                    final compra = acao!.historicoCompras[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(
                          'Qtd: ${compra.quantidade} | Preço: R\$ ${compra.preco.toStringAsFixed(2)}',
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirDialogComprarMais,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text("Comprar Mais"),
      ),
    );
  }
}
