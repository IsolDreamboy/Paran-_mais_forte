import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/obra.dart';

import '../widgets/section_title.dart';

class ObrasScreen extends StatefulWidget {
  const ObrasScreen({super.key});

  @override
  State<ObrasScreen> createState() => _ObrasScreenState();
}

class _ObrasScreenState extends State<ObrasScreen> {
  final api = ApiClient("http://localhost:8000");

  bool loading = true;
  List<Obra> obras = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    try {
      final data = await api.get(Endpoints.obras);
      obras = (data as List).map((e) => Obra.fromJson(e)).toList();
    } catch (e) {
      obras = [];
    }
    setState(() => loading = false);
  }

  // Define cor por status
  Color _statusColor(String status) {
    status = status.toLowerCase();

    if (status.contains("concluído")) {
      return const Color(0xFF2E7D32); // verde
    }
    if (status.contains("exec")) { // em execução
      return const Color(0xFFFFA000); // amarelo
    }
    return const Color(0xFF0055A4); // azul planejado/outros
  }

  IconData _statusIcon(String status) {
    status = status.toLowerCase();

    if (status.contains("concluído")) {
      return Icons.check_circle;
    }
    if (status.contains("exec")) {
      return Icons.build;
    }
    return Icons.pending;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Serviços e Obras")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  SectionTitle("Status das Obras"),

                  ...obras.map((obra) {
                    final c = _statusColor(obra.status);

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
                            Icon(
                              _statusIcon(obra.status),
                              color: c,
                              size: 36,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    obra.servico,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    obra.local,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: c.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: c.withOpacity(0.4),
                                      ),
                                    ),
                                    child: Text(
                                      obra.status,
                                      style: TextStyle(
                                        color: c,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  if (obra.observacoes.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Text(
                                      obra.observacoes,
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
