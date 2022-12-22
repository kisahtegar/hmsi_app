import 'package:flutter/material.dart';
import 'package:hmsi_app/features/presentation/pages/main_screen/main_screen.dart';

import 'on_generate_route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HMSI App',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: OnGenerateRoute.route,
      initialRoute: '/',
      routes: {
        "/": (context) {
          return const MainScreen();
        }
      },
    );
  }
}
