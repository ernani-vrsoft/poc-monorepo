import 'package:flutter/material.dart';

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
    );
  }
}
