import 'package:flutter/material.dart';

import 'core/app_version.dart';
import 'pages/pessoa_list_page.dart';

void main() {
  runApp(const PdvApp());
}

class PdvApp extends StatelessWidget {
  const PdvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const PessoaListPage(),
      builder: (context, child) => Column(
        children: [
          Expanded(child: child!),
          const _VersionFooter(),
        ],
      ),
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  static final _version = loadAppVersion();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Align(
          alignment: Alignment.centerRight,
          child: FutureBuilder<String>(
            future: _version,
            builder: (_, snap) => Text(
              'Versão ${snap.data ?? '...'}',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ),
      ),
    );
  }
}
