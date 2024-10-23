import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class MotivationalQuoteRepository {
  final String apiUrl = "https://api.quotable.io/random";

  Future<String> fetchQuote() async {
    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final request = await client.getUrl(Uri.parse(apiUrl));
      final response = await request.close();

      if (response.statusCode == 200) {
        final String responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody);
        log('Frase carregada: ${data['content']}');
        return data['content'] ?? 'Frase não encontrada.'; 
      } else {
        throw Exception('Falha ao carregar frase: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro: $error');
    }
  }
}
