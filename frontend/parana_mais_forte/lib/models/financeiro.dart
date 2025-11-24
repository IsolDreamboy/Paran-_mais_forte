class Financeiro {
  final String programa;
  final double valor;
  final String status;

  Financeiro({
    required this.programa,
    required this.valor,
    required this.status,
  });

  factory Financeiro.fromJson(Map<String, dynamic> json) {
    return Financeiro(
      programa: json["Programa"],
      valor: double.tryParse(
            json["Valor Total (R\$)"].toString().replaceAll(",", "."),
          ) ??
          0,
      status: json["Status"],
    );
  }
}
