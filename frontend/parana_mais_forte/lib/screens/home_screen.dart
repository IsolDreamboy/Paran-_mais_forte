import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/clima.dart';
import '../models/doacao.dart';
import '../models/obra.dart';
import '../models/financeiro.dart';

import '../widgets/card_metric.dart';
import '../widgets/section_title.dart';
import 'financeiros_screen.dart';
import 'obras_screen.dart';
import 'doacoes_screen.dart';
import 'danos_screen.dart';
import 'clima_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ApiClient("http://localhost:8000");

  bool loading = true;

  List<Financeiro> financeiros = [];
  List<Doacao> doacoes = [];
  List<Obra> obras = [];
  Clima? clima;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    try {
      financeiros = (await api.get(Endpoints.financeiros) as List)
          .map((e) => Financeiro.fromJson(e))
          .toList();

      doacoes =
          (await api.get(Endpoints.doacoes) as List).map((e) => Doacao.fromJson(e)).toList();

      obras =
          (await api.get(Endpoints.obras) as List).map((e) => Obra.fromJson(e)).toList();

      clima = Clima.fromJson(await api.get(Endpoints.clima));
    } catch (e) {
      financeiros = [];
      doacoes = [];
      obras = [];
      clima = null;
    }

    setState(() => loading = false);
  }

  double get totalFinanceiro =>
      financeiros.fold(0, (s, e) => s + e.valor);

  int get totalDoacoes => doacoes.length;

  int get totalObras => obras.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paraná Mais Forte"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ============================================================
                // BANNER
                // ============================================================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0055A4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield, color: Colors.white, size: 40),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Dashboard de Monitoramento\nParaná Mais Forte",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // ============================================================
                // MÉTRICAS RESUMIDAS
                // ============================================================
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CardMetric(
                        label: "Total Financeiro",
                        value: "R\$ ${totalFinanceiro.toStringAsFixed(2)}",
                        icon: Icons.monetization_on,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CardMetric(
                        label: "Obras",
                        value: "$totalObras",
                        icon: Icons.construction,
                        color: const Color(0xFF0055A4),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                CardMetric(
                  label: "Doações cadastradas",
                  value: "$totalDoacoes",
                  icon: Icons.volunteer_activism,
                  color: const Color(0xFF8E24AA),
                ),

                // ============================================================
                // CLIMA
                // ============================================================
                if (clima != null) ...[
                  const SectionTitle("Clima Atual"),
                  _cardClima(clima!),
                ],

                // ============================================================
                // SEÇÕES
                // ============================================================
                const SectionTitle("Acessar Módulos"),

                _menuItem(
                  "Recursos Financeiros",
                  Icons.account_balance,
                  () => _go(const FinanceirosScreen()),
                ),
                _menuItem(
                  "Serviços e Obras",
                  Icons.engineering,
                  () => _go(const ObrasScreen()),
                ),
                _menuItem(
                  "Doações",
                  Icons.volunteer_activism,
                  () => _go(const DoacoesScreen()),
                ),
                _menuItem(
                  "Danos Humanos",
                  Icons.people,
                  () => _go(const DanosScreen()),
                ),
                _menuItem(
                  "Monitoramento do Clima",
                  Icons.cloud,
                  () => _go(const ClimaScreen()),
                ),
              ],
            ),
    );
  }

  Widget _menuItem(String title, IconData icon, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0055A4)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _go(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Widget _cardClima(Clima clima) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.thermostat, size: 40, color: Color(0xFF0055A4)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Temperatura: ${clima.temperatura} °C\n"
                "Vento: ${clima.ventoKmh.toStringAsFixed(1)} km/h\n"
                "Condição: ${clima.descricao}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
