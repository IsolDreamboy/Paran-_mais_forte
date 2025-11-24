class Obra {
  final String servico;
  final String local;
  final String status;
  final String observacoes;

  Obra({
    required this.servico,
    required this.local,
    required this.status,
    required this.observacoes,
  });

  factory Obra.fromJson(Map<String, dynamic> json) {
    return Obra(
      servico: json["Serviço"],
      local: json["Localização"],
      status: json["Status"],
      observacoes: json["Observações"] ?? "",
    );
  }
}
