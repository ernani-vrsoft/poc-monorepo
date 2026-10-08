import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../services/pessoa_service.dart';

class PessoaFormPage extends StatefulWidget {
  final PessoaService service;
  final Pessoa? pessoa;

  const PessoaFormPage({super.key, required this.service, this.pessoa});

  @override
  State<PessoaFormPage> createState() => _PessoaFormPageState();
}

class _PessoaFormPageState extends State<PessoaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeCtrl;
  bool _salvando = false;

  bool get _editando => widget.pessoa != null;

  @override
  void initState() {
    super.initState();
    _nomeCtrl = TextEditingController(text: widget.pessoa?.nome ?? '');
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);
    try {
      final nome = _nomeCtrl.text.trim();
      if (_editando) {
        await widget.service.atualizar(widget.pessoa!.id!, nome);
      } else {
        await widget.service.criar(nome);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Falha ao salvar: $e')));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar pessoa' : 'Nova pessoa'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomeCtrl,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Informe o nome'
                        : null,
                    onFieldSubmitted: (_) => _salvar(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _salvando ? null : _salvar,
                    icon: _salvando
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: const Text('Salvar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
