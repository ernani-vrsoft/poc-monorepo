import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../models/pessoa.dart';

class PessoaService {
  final http.Client _client;

  PessoaService({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri([String path = '']) =>
      Uri.parse('${ApiConfig.baseUrl}/pessoas$path');

  static const _headers = {'Content-Type': 'application/json'};

  Future<List<Pessoa>> listar() async {
    final res = await _client.get(_uri());
    _check(res);
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => Pessoa.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Pessoa> criar(String nome) async {
    final res = await _client.post(
      _uri(),
      headers: _headers,
      body: jsonEncode(Pessoa(nome: nome).toJson()),
    );
    _check(res);
    return Pessoa.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Pessoa> atualizar(String id, String nome) async {
    final res = await _client.put(
      _uri('/$id'),
      headers: _headers,
      body: jsonEncode(Pessoa(nome: nome).toJson()),
    );
    _check(res);
    return Pessoa.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deletar(String id) async {
    final res = await _client.delete(_uri('/$id'));
    _check(res);
  }

  void _check(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    String msg = 'Erro ${res.statusCode}';
    try {
      msg = (jsonDecode(res.body) as Map<String, dynamic>)['erro'] ?? msg;
    } catch (_) {}
    throw Exception(msg);
  }
}
