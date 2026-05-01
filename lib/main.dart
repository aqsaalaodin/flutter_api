import 'package:flutter/material.dart';
import 'package:flutter_api/login_screen.dart';
//import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D4FF),
          secondary: Color(0xFFFFB347),
          surface: Color(0xFF111827),
        ),
        fontFamily: 'Poppins',
      ),
      home: const LoginScreen(),
    );
  }
}