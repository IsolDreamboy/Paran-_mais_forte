class DanoHumano {
  final String tipo;
  final String quantidade;
  final String observacoes;

  DanoHumano({
    required this.tipo,
    required this.quantidade,
    required this.observacoes,
  });

  factory DanoHumano.fromJson(Map<String, dynamic> json) {
    return DanoHumano(
      tipo: json["Tipo"],
      quantidade: json["Quantidade"].toString(),
      observacoes: json["Observações"] ?? "",
    );
  }
}
