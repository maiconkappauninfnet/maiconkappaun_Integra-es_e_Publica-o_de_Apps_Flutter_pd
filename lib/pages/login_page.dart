import 'package:auth_maicon/auth_maicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/routes.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool _obscureText = true;

  void autenticar(BuildContext context) {
    String email = emailController.text;
    String senha = senhaController.text;
    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    } else {
      AuthMaicon authProvider = Provider.of<AuthMaicon>(
        context,
        listen: false,
      );

      authProvider.signIn(email, senha).then((response) {
        if (response) {
          Navigator.pushNamed(context, Routes.DASHBOARD);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Bem vindo(a)!')));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Erro no login.')));
        }
      });
    }
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _toggleVisibility,
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  autenticar(context);
                },
                child: Text("Acessar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.CADASTRO_USUARIO);
                },
                child: Text("Cadastrar-se"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
