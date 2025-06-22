import 'dart:convert';
import 'package:http/http.dart' as http;

class BrapiService {
  static const String _baseUrl = 'https://brapi.dev/api/quote/';
  static const String _token = 'o74HCpk6xjxENWvPcq4XAg';

  static Future<double?> buscarPrecoAtual(String codigoAcao) async {
    final url = Uri.parse('$_baseUrl$codigoAcao');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final preco = data['results'][0]['regularMarketPrice'];
        return preco != null ? double.tryParse(preco.toString()) : null;
      } else {
        print('Erro HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro na API: $e');
      return null;
    }
  }
}
