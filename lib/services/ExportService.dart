import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_application_2/models/acoes.dart';
import 'package:path/path.dart' as path;

class ExportService {
  static Future<void> exportarAcoesParaArquivo(List<Acao> acoes) async {
    try {
      String? directoryPath = await getDirectoryPath();

      if (directoryPath == null) {
        print('Seleção cancelada pelo usuário');
        return;
      }

      StringBuffer buffer = StringBuffer();
      buffer.writeln('Código,Preço Médio,Quantidade,Preço Atual,Total Investido');

      for (var acao in acoes) {
        buffer.writeln(
          '${acao.codigo},'
          '${acao.precoMedio},'
          '${acao.quantidade},'
          '${acao.precoAtual},'
          '${acao.totalInvestido}',
        );
      }

      String filePath = path.join(directoryPath, 'acoes_exportadas.csv');

      File file = File(filePath);
      await file.writeAsString(buffer.toString());

      print('Arquivo exportado em: $filePath');
    } catch (e) {
      print('Erro ao exportar: $e');
    }
  }
}
