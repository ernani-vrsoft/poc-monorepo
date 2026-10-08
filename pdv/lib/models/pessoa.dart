class Pessoa {
  final String? id;
  final String nome;

  const Pessoa({this.id, required this.nome});

  factory Pessoa.fromJson(Map<String, dynamic> json) =>
      Pessoa(id: json['id'] as String?, nome: json['nome'] as String);

  Map<String, dynamic> toJson() => {'nome': nome};
}
