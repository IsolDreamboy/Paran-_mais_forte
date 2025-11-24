class Clima {
  final double temperatura;
  final double ventoKmh;
  final String descricao;
  final String? alerta;

  Clima({
    required this.temperatura,
    required this.ventoKmh,
    required this.descricao,
    this.alerta,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      temperatura: (json["temp"] ?? 0).toDouble(),
      ventoKmh: (json["vento_kmh"] ?? 0).toDouble(),
      descricao: json["descricao"] ?? "",
      alerta: json["alerta"],
    );
  }
}
