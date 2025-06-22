import 'package:auth_maicon/auth_maicon.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:flutter_application_2/pages/acao_form_page.dart';
import 'package:flutter_application_2/pages/cadastro_usuario_page.dart';
import 'package:flutter_application_2/pages/dashboard_page.dart';
import 'package:flutter_application_2/pages/login_page.dart';
import 'package:flutter_application_2/pages/acao_page.dart';
import 'package:flutter_application_2/providers/acoes_provider.dart';
import 'package:flutter_application_2/routes.dart';
import 'package:flutter_application_2/services/AcoesService.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthMaicon>(create: (context) => AuthMaicon()),
        ChangeNotifierProvider(
          create: (context) => AcoesProvider(AcoesService()),
        ),
      ],
      child: MaterialApp(
        title: 'Live Investing',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 45, 59, 56),
          ),
        ),
        routes: {
          Routes.LOGIN: (context) => LoginPage(),
          Routes.DASHBOARD: (context) => DashboardPage(),
          Routes.CADASTRO_USUARIO: (context) => CadastroUsuarioPage(),
          Routes.ACAO: (context) => AcaoPage(),
          Routes.ACAO_FORM: (context) => AcaoFormPage(),
        },
      ),
    );
  }
}