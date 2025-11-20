import 'package:demalu/data/auth/storage_service.dart';
import 'package:demalu/data/modules/budget_module/service/budgets_service.dart';
import 'package:demalu/ui/screens/home/home_screen.dart';
import 'package:demalu/ui/screens/login/login_screen.dart';
import 'package:demalu/ui/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final geminiApiKey = dotenv.get("GEMINI_API_KEY");
  Gemini.init(apiKey: geminiApiKey, enableDebugging: false);
  await StorageService.instance.init();

  runApp(MultiProvider(
      providers: [
        Provider<BudgetsService>(create: (context) => BudgetsService()),
      ],
      child: const MyApp(), 
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(), //home screen after login
    );
  }
}