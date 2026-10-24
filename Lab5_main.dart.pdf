import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mortgage_provider.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      create: (_) => MortgageProvider(prefs),
      child: const MortgageApp(),
    ),
  );
}

class MortgageApp extends StatelessWidget {
  const MortgageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MortgageV0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MainScreen(),
    );
  }
}
