import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Text(
              "Paraná Mais Forte",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          _item(context, "Início", Icons.home, "/"),
          _item(context, "Recursos Financeiros", Icons.account_balance, "/financeiros"),
          _item(context, "Serviços e Obras", Icons.engineering, "/obras"),
          _item(context, "Doações", Icons.volunteer_activism, "/doacoes"),
          _item(context, "Danos Humanos", Icons.people, "/danos"),
          _item(context, "Clima", Icons.cloud, "/clima"),
        ],
      ),
    );
  }

  ListTile _item(BuildContext ctx, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      onTap: () {
        Navigator.pop(ctx);
        Navigator.pushNamed(ctx, route);
      },
    );
  }
}
