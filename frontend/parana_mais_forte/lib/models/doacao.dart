class Doacao {
  final String tipo;
  final String quantidade;
  final String detalhes;

  Doacao({
    required this.tipo,
    required this.quantidade,
    required this.detalhes,
  });

  factory Doacao.fromJson(Map<String, dynamic> json) {
    return Doacao(
      tipo: json["Tipo de Doação"],
      quantidade: json["Quantidade/Valor"],
      detalhes: json["Status/Detalhes"],
    );
  }
}
