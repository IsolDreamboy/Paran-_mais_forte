import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/clima.dart';
import '../widgets/section_title.dart';

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  final api = ApiClient("http://localhost:8000");

  bool loading = true;
  Clima? clima;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    try {
      clima = Clima.fromJson(await api.get(Endpoints.clima));
    } catch (e) {
      clima = null;
    }
    setState(() => loading = false);
  }

  IconData _iconPorClima(String desc) {
    desc = desc.toLowerCase();

    if (desc.contains("chuva")) return Icons.umbrella;
    if (desc.contains("nublado")) return Icons.cloud;
    if (desc.contains("nuvens")) return Icons.cloud_queue;
    if (desc.contains("limpo")) return Icons.wb_sunny;
    if (desc.contains("tempest")) return Icons.flash_on;
    if (desc.contains("nebl")) return Icons.blur_on;

    return Icons.wb_cloudy;
  }

  Color _corPorClima(String desc) {
    desc = desc.toLowerCase();

    if (desc.contains("chuva")) return Colors.blue.shade700;
    if (desc.contains("tempest")) return Colors.deepPurple;
    if (desc.contains("limpo")) return Colors.orange.shade700;
    if (desc.contains("nublado")) return Colors.blueGrey;

    return const Color(0xFF0055A4); // padrão
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monitoramento do Clima")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : clima == null
              ? const Center(child: Text("Falha ao carregar dados do clima"))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      // ======================================================
                      // CARD PRINCIPAL DE CLIMA
                      // ======================================================
                      _cardClimaPrincipal(),

                      const SectionTitle("Informações Detalhadas"),

                      // ======================================================
                      // CARTÃO DO VENTO
                      // ======================================================
                      _cardVento(),

                      // ======================================================
                      // ALERTA (caso exista)
                      // ======================================================
                      if (clima!.alerta != null) ...[
                        const SectionTitle("Alerta"),
                        _cardAlerta(clima!.alerta!),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _cardClimaPrincipal() {
    final cor = _corPorClima(clima!.descricao);
    final icon = _iconPorClima(clima!.descricao);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: cor, size: 70),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${clima!.temperatura.toStringAsFixed(1)} °C",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: cor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    clima!.descricao,
                    style: TextStyle(
                      fontSize: 18,
                      color: cor.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardVento() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.air, size: 40, color: Colors.blueGrey),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Velocidade do Vento:\n${clima!.ventoKmh.toStringAsFixed(1)} km/h",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardAlerta(String texto) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
