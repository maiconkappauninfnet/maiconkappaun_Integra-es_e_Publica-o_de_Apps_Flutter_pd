import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/acoes.dart';
import 'package:flutter_application_2/providers/acoes_provider.dart';
import 'package:provider/provider.dart';

class AcaoForm extends StatefulWidget {
  final Acao? acao;

  const AcaoForm({super.key, this.acao});

  @override
  State<AcaoForm> createState() => _AcaoFormState();
}

class _AcaoFormState extends State<AcaoForm> {
  final codigoController = TextEditingController();
  final quantidadeController = TextEditingController();
  final precoAtualController = TextEditingController();
  final FocusNode _codigoFocusNode = FocusNode();

  Timer? _debounce;
  String? _message;
  bool _ativoValido = false;

  @override
  void initState() {
    super.initState();

    if (widget.acao != null) {
      codigoController.text = widget.acao!.codigo;
      quantidadeController.text = widget.acao!.quantidade.toString();
      precoAtualController.text = widget.acao!.precoAtual.toString();
      _ativoValido = true;
    }

    codigoController.addListener(() {
      final currentText = codigoController.text;
      if (currentText != currentText.toUpperCase()) {
        final cursorPosition = codigoController.selection;
        codigoController.value = TextEditingValue(
          text: currentText.toUpperCase(),
          selection: cursorPosition,
        );
      }

      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 800), () {
        _buscarPrecoAtual();
      });
    });
  }

  Future<void> _buscarPrecoAtual() async {
    final codigo = codigoController.text.trim();
    if (codigo.isNotEmpty) {
      final provider = Provider.of<AcoesProvider>(context, listen: false);
      final preco =  await provider.getPrecoAtual(codigo);
      if (preco != null) {
        setState(() {
          precoAtualController.text = preco.toStringAsFixed(2);
          _ativoValido = true;
          _message = null;
        });
      } else {
        setState(() {
          precoAtualController.text = "";
          _ativoValido = false;
          _message = "Ativo não encontrado. Por favor, revise o código.";
        });
      }
    }
  }

  @override
  void dispose() {
    codigoController.dispose();
    quantidadeController.dispose();
    precoAtualController.dispose();
    _codigoFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final acoesProvider = Provider.of<AcoesProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          TextField(
            controller: codigoController,
            focusNode: _codigoFocusNode,
            decoration: const InputDecoration(
              labelText: 'Código da Ação',
              hintText: 'Exemplo: PETR4',
            ),
          ),
          TextField(
            controller: quantidadeController,
            decoration: const InputDecoration(labelText: 'Quantidade'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: precoAtualController,
            decoration: const InputDecoration(
              labelText: 'Preço Atual',
              fillColor: Color.fromARGB(255, 220, 235, 221),
              filled: true,
            ),
            style: const TextStyle(color: Colors.black54),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            readOnly: true,
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              try {
                final codigo = codigoController.text.trim();
                final quantidade =
                    int.tryParse(quantidadeController.text.trim()) ?? 0;
                final precoAtual =
                    double.tryParse(precoAtualController.text.trim()) ?? 0;

                if (!_ativoValido) {
                  setState(() {
                    _message = "Por favor, informe um código de ação válido.";
                  });
                  return;
                }

                if (codigo.isEmpty || quantidade <= 0) {
                  setState(() {
                    _message = "Preencha todos os campos obrigatórios.";
                  });
                  return;
                }

                final novaAcao = Acao(
                  id: '',
                  codigo: codigo,
                  precoMedio: precoAtual,
                  quantidade: quantidade,
                  precoAtual: precoAtual,
                );

                await acoesProvider.add(novaAcao);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ação adicionada')),
                );
                Navigator.pop(context);
              } catch (e) {
                setState(() {
                  _message = e.toString().replaceAll('Exception:', '').trim();
                });
              }
            },
            child: const Text("Salvar"),
          ),

          if (_message != null) ...[
            const SizedBox(height: 10),
            Text(_message!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
    );
  }
}
