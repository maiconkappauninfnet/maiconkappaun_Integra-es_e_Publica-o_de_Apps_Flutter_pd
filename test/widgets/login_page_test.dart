import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/pages/login_page.dart';
import 'package:auth_maicon/auth_maicon.dart';
import 'package:provider/provider.dart';

Widget createLoginPage() => ChangeNotifierProvider(
  create: (context) => AuthMaicon(),
  child: MaterialApp(home: LoginPage()),
);

void main() {
  group("Testando widget LoginPage", () {
    testWidgets("Deve exibir input de email requerido", (tester) async {
      await tester.pumpWidget(createLoginPage());

      final inputEmail = find.widgetWithText(TextField, "E-mail");
      expect(inputEmail, findsOneWidget);

      final inputSenha = find.widgetWithText(TextField, "Senha");
      expect(inputSenha, findsOneWidget);

      expect(find.text("Acessar"), findsOneWidget);

      await tester.tap(find.text("Acessar"));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text("Por favor, preencha todos os campos."), findsOneWidget);
    });
  });
}
