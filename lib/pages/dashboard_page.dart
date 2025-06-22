import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/acoes_lista.dart';
import 'package:flutter_application_2/models/acoes.dart';
import 'package:flutter_application_2/providers/acoes_provider.dart';
import 'package:flutter_application_2/routes.dart';
import 'package:flutter_application_2/services/ExportService.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  Acao? acaoSelecionada;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AcoesProvider>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final acoesProvider = Provider.of<AcoesProvider>(context);
    final analise = acoesProvider.analiseGeral;

    final appBar = AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Live Investing - Carteira"),
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          tooltip: 'Exportar Ações',
          onPressed: () async {
            final listaAcoes = acoesProvider.acoes ?? [];
            await ExportService.exportarAcoesParaArquivo(listaAcoes);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exportação finalizada!')),
            );
          },
        ),
      ],
    );

    final mediaQuery = MediaQuery.of(context);
    final bool isPortrait = mediaQuery.orientation == Orientation.portrait;
    final height =
        mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;

    Widget createCircularIndicator() =>
        const Center(child: CircularProgressIndicator());

    Widget createCenterErrorMessage() =>
        Center(child: Text(acoesProvider.error ?? 'Erro desconhecido'));

    Widget createCenterNoItemMessage() =>
        const Center(child: Text("Nenhuma ação cadastrada."));

    Widget createDashboardBody() {
      List<Acao>? acoes = acoesProvider.acoes;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Card(
                color: Colors.green[50],
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Análise da Carteira:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Total Investido: R\$ ${analise.totalInvestido.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Valor Atual: R\$ ${analise.valorAtual.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Lucro / Prejuízo: R\$ ${analise.lucroTotal.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              analise.lucroTotal >= 0
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                      Text(
                        "Rentabilidade: ${analise.rentabilidadePercentual.toStringAsFixed(2)}%",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              analise.rentabilidadePercentual >= 0
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (acoes != null)
              AcoesLista(acoes, () {}, height, isPortrait: isPortrait),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body:
          acoesProvider.isLoading
              ? createCircularIndicator()
              : (acoesProvider.error != null && acoesProvider.error!.isNotEmpty)
              ? createCenterErrorMessage()
              : (acoesProvider.acoes != null && acoesProvider.acoes!.isEmpty)
              ? createCenterNoItemMessage()
              : createDashboardBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.ACAO_FORM);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
