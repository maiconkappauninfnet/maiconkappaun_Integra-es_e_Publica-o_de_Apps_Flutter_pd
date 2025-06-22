import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/acao_form.dart';

class AcaoFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Nova ação"),
      ),
      body: AcaoForm(),
    );
  }
}