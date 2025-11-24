import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse(baseUrl + endpoint);

    final r = await http.get(uri);

    if (r.statusCode >= 200 && r.statusCode < 300) {
      return jsonDecode(r.body);
    }

    throw Exception("Erro ao acessar $endpoint (${r.statusCode})");
  }
}
