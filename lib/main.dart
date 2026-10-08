import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const CargoFlowApp());
}

class CargoFlowApp extends StatelessWidget {
  const CargoFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF176B5B);

    return MaterialApp(
      title: 'CargoFlow Logistics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          primary: seedColor,
          secondary: const Color(0xFFF0A93B),
          surface: const Color(0xFFF7F8F6),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F8F6),
          foregroundColor: Color(0xFF17221F),
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE4E9E5)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD8E0DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD8E0DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: seedColor, width: 1.8),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
