import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Paraná Mais Forte",
      debugShowCheckedModeBanner: false,

      theme: appTheme(),
      initialRoute: "/",
      routes: appRoutes,
    );
  }
}
