import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/financeiros_screen.dart';
import 'screens/obras_screen.dart';
import 'screens/doacoes_screen.dart';
import 'screens/danos_screen.dart';
import 'screens/clima_screen.dart';

Map<String, WidgetBuilder> appRoutes = {
  "/": (context) => const HomeScreen(),
  "/financeiros": (context) => const FinanceirosScreen(),
  "/obras": (context) => const ObrasScreen(),
  "/doacoes": (context) => const DoacoesScreen(),
  "/danos": (context) => const DanosScreen(),
  "/clima": (context) => const ClimaScreen(),
};
