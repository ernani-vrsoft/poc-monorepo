import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../services/pessoa_service.dart';
import 'pessoa_form_page.dart';

class PessoaListPage extends StatefulWidget {
  const PessoaListPage({super.key});

  @override
  State<PessoaListPage> createState() => _PessoaListPageState();
}

class _PessoaListPageState extends State<PessoaListPage> {
  final _service = PessoaService();
  List<Pessoa> _pessoas = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final pessoas = await _service.listar();
      setState(() => _pessoas = pessoas);
    } catch (e) {
      setState(() => _erro = e.toString());
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _abrirForm([Pessoa? pessoa]) async {
    final salvou = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PessoaFormPage(service: _service, pessoa: pessoa),
      ),
    );
    if (salvou == true) _carregar();
  }

  Future<void> _deletar(Pessoa pessoa) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir pessoa'),
        content: Text('Deseja excluir "${pessoa.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou != true) return;

    try {
      await _service.deletar(pessoa.id!);
      _carregar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Falha ao excluir: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas'),
        actions: [
          IconButton(
            tooltip: 'Recarregar',
            onPressed: _carregar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirForm(),
        icon: const Icon(Icons.add),
        label: const Text('Nova'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Erro ao carregar: $_erro'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _carregar,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    if (_pessoas.isEmpty) {
      return const Center(child: Text('Nenhuma pessoa cadastrada'));
    }
    return ListView.separated(
      itemCount: _pessoas.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final p = _pessoas[i];
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(p.nome),
          onTap: () => _abrirForm(p),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Editar',
                onPressed: () => _abrirForm(p),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                tooltip: 'Excluir',
                onPressed: () => _deletar(p),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        );
      },
    );
  }
}
