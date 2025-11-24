import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/doacao.dart';

import '../widgets/card_metric.dart';
import '../widgets/card_list_tile.dart';
import '../widgets/section_title.dart';
import 'package:flutter/services.dart';

class DoacoesScreen extends StatefulWidget {
  const DoacoesScreen({super.key});

  @override
  State<DoacoesScreen> createState() => _DoacoesScreenState();
}

class _DoacoesScreenState extends State<DoacoesScreen> {
  final api = ApiClient("http://localhost:8000");

  bool loading = true;
  List<Doacao> lista = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await api.get(Endpoints.doacoes);
      lista = (data as List).map((e) => Doacao.fromJson(e)).toList();
    } catch (e) {
      lista = [];
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final totalTipos = lista.length;
    final totalMateriais = _totalMateriais();
    final pixKey = _getPixKey();

    return Scaffold(
      appBar: AppBar(title: const Text("Doações")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  // ==================== CARDS DO TOPO ====================
                  Row(
                    children: [
                      Expanded(
                        child: CardMetric(
                          label: "Tipos de doação",
                          value: "$totalTipos",
                          icon: Icons.volunteer_activism,
                          color: const Color(0xFF0055A4),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CardMetric(
                          label: "Materiais arrecadados",
                          value: totalMateriais,
                          icon: Icons.inventory,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),

                  // ==================== PIX ====================
                  if (pixKey != null) ...[
                    const SectionTitle("Doação por PIX"),
                    _pixCard(pixKey),
                  ],

                  const SectionTitle("Lista de Doações"),

                  // ==================== LISTA ====================
                  ...lista.map((d) {
                    return CardListTile(
                      title: d.tipo,
                      subtitle: "Quantidade / Valor: ${d.quantidade}",
                      badge: d.detalhes,
                    );
                  }),
                ],
              ),
            ),
    );
  }

  // ==================== FUNÇÕES AUXILIARES ====================

  String _totalMateriais() {
    final entry = lista.firstWhere(
      (e) => e.tipo.contains("Materiais"),
      orElse: () => Doacao(tipo: "", quantidade: "0", detalhes: ""),
    );
    return entry.quantidade;
  }

  String? _getPixKey() {
    final entry = lista.firstWhere(
      (e) => e.tipo.toLowerCase().contains("pix"),
      orElse: () => Doacao(tipo: "", quantidade: "", detalhes: ""),
    );

    if (entry.detalhes.contains("PIX:")) {
      return entry.detalhes.split("PIX:").last.trim();
    }
    return null;
  }

  Widget _pixCard(String key) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.qr_code, size: 40, color: Color(0xFF0055A4)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "PIX para doações:\n$key",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: key));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Chave PIX copiada!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
