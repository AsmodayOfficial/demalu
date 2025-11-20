import 'package:demalu/ui/screens/home/home_screen.dart';
import 'package:demalu/ui/screens/login/login_screen.dart';
import 'package:demalu/ui/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

void main() {
  Gemini.init(apiKey: geminiApiKey, enableDebugging: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}