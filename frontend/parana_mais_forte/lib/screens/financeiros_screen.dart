import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/financeiro.dart';
import '../widgets/card_metric.dart';
import '../widgets/card_list_tile.dart';
import '../widgets/section_title.dart';

class FinanceirosScreen extends StatefulWidget {
  const FinanceirosScreen({super.key});

  @override
  State<FinanceirosScreen> createState() => _FinanceirosScreenState();
}

class _FinanceirosScreenState extends State<FinanceirosScreen> {
  final api = ApiClient("http://localhost:8000");

  bool loading = true;
  List<Financeiro> lista = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final r = await api.get(Endpoints.financeiros);
      lista = (r as List).map((e) => Financeiro.fromJson(e)).toList();
    } catch (e) {
      lista = [];
    }

    setState(() => loading = false);
  }

  double get total {
    return lista.fold(0, (s, e) => s + e.valor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recursos Financeiros")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CardMetric(
                          label: "Total Recebido",
                          value: "R\$ ${total.toStringAsFixed(2)}",
                          icon: Icons.account_balance_wallet,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CardMetric(
                          label: "Programas",
                          value: "${lista.length}",
                          icon: Icons.list_alt,
                        ),
                      ),
                    ],
                  ),

                  const SectionTitle("Fontes de Recurso"),

                  ...lista.map((f) {
                    return CardListTile(
                      title: f.programa,
                      subtitle: "R\$ ${f.valor.toStringAsFixed(2)}",
                      badge: f.status,
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
