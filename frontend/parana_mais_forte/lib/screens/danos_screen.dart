import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/dano_humano.dart';
import '../widgets/section_title.dart';

class DanosScreen extends StatefulWidget {
  const DanosScreen({super.key});

  @override
  State<DanosScreen> createState() => _DanosScreenState();
}

class _DanosScreenState extends State<DanosScreen> {
  final api = ApiClient("http://localhost:8000");

  bool loading = true;
  List<DanoHumano> danos = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    try {
      final data = await api.get(Endpoints.danos);
      danos = (data as List).map((e) => DanoHumano.fromJson(e)).toList();
    } catch (e) {
      danos = [];
    }
    setState(() => loading = false);
  }

  Color _corTipo(String tipo) {
    tipo = tipo.toLowerCase();

    if (tipo.contains("desaloj")) return Colors.orange;
    if (tipo.contains("desabrig")) return Colors.red.shade700;
    if (tipo.contains("ferid")) return Colors.amber.shade700;

    return const Color(0xFF0055A4); // azul padrão
  }

  IconData _iconTipo(String tipo) {
    tipo = tipo.toLowerCase();

    if (tipo.contains("desaloj")) return Icons.home_work_outlined;
    if (tipo.contains("desabrig")) return Icons.house_siding_outlined;
    if (tipo.contains("ferid")) return Icons.health_and_safety;

    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danos Humanos")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  SectionTitle("Impactos na População"),

                  ...danos.map((d) {
                    final cor = _corTipo(d.tipo);

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(_iconTipo(d.tipo), color: cor, size: 36),
                            const SizedBox(width: 16),

                            // Conteúdo
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    d.tipo,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 6),
                                  Text(
                                    "Quantidade: ${d.quantidade}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: cor,
                                    ),
                                  ),

                                  if (d.observacoes.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Text(
                                      d.observacoes,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
