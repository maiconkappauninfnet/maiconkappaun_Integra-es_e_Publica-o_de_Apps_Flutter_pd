import 'package:auth_maicon/auth_maicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/routes.dart';
import 'package:provider/provider.dart';

class CadastroUsuarioPage extends StatefulWidget {
  @override
  _CadastroUsuarioPageState createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final resenhaController = TextEditingController();

  bool _obscureSenha = true;
  bool _obscureResenha = true;

  void cadastrarUsuario(BuildContext context) {
    final email = emailController.text;
    final senha1 = senhaController.text;
    final senha2 = resenhaController.text;

    if (email.isEmpty || senha1.isEmpty || senha2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }
    String senha = senhaController.text;
    String resenha = resenhaController.text;
    if (senha == resenha) {
      String email = emailController.text;
      AuthMaicon authProvider = Provider.of<AuthMaicon>(
        context,
        listen: false,
      );
      authProvider.signUp(email, senha).then((resposta) {
        if (resposta) {
          Navigator.pushReplacementNamed(context, Routes.DASHBOARD);
        } else {
          // TODO: Mostrar erro (Snackbar ou AlertDialog)
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não são iguais.')),
      );
    }
  }

  void _toggleSenhaVisibility() {
    setState(() {
      _obscureSenha = !_obscureSenha;
    });
  }

  void _toggleResenhaVisibility() {
    setState(() {
      _obscureResenha = !_obscureResenha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'E-mail'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: senhaController,
                obscureText: _obscureSenha,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureSenha ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _toggleSenhaVisibility,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: resenhaController,
                obscureText: _obscureResenha,
                decoration: InputDecoration(
                  hintText: 'Repetir a senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureResenha ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _toggleResenhaVisibility,
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => cadastrarUsuario(context),
                child: Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
