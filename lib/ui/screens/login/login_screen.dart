import 'package:demalu/core/color_log.dart';
import 'package:demalu/data/auth/auth_service.dart';
import 'package:demalu/ui/screens/home/home_screen.dart'; 
import 'package:demalu/ui/widgets/custom_button.dart';
import 'package:demalu/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService(); 

  final _loginUsernameController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _regUsernameController = TextEditingController();
  final _regPasswordController = TextEditingController();
  final _regConfirmPasswordController = TextEditingController();
  final _regPhoneController = TextEditingController(); 

  bool _isLoading = false; 

  @override
  void dispose() {
    _loginUsernameController.dispose();
    _loginPasswordController.dispose();
    _regUsernameController.dispose();
    _regPasswordController.dispose();
    _regConfirmPasswordController.dispose();
    _regPhoneController.dispose();
    super.dispose();
  }

  // Метод для показа ошибок
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Логика входа
  Future<void> _handleLogin() async {
    if (_loginUsernameController.text.isEmpty || _loginPasswordController.text.isEmpty) {
      _showError("Заполните все поля");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _authService.login(
        _loginUsernameController.text,
        _loginPasswordController.text,
      );

      if (success && mounted) {
        colorLog("Login success", color: 'green');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (e is DioException) {
         _showError(e.response?.data['detail'] ?? "Ошибка авторизации");
      } else {
        _showError("Произошла ошибка");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Логика регистрации
  Future<void> _handleRegister() async {
    if (_regUsernameController.text.isEmpty ||
        _regPasswordController.text.isEmpty ||
        _regPhoneController.text.isEmpty) {
      _showError("Заполните все поля");
      return;
    }

    if (_regPasswordController.text != _regConfirmPasswordController.text) {
      _showError("Пароли не совпадают");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _authService.register(
        _regUsernameController.text,
        _regPasswordController.text,
        _regPhoneController.text,
      );

      if (success && mounted) {
        colorLog("Register success", color: 'green');
        // После регистрации сразу переходим на главный экран (если токен вернулся)
        // Или можно показать уведомление и переключить на вкладку входа
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (e is DioException) {
         _showError(e.response?.data['detail'] ?? "Ошибка регистрации");
      } else {
        _showError("Произошла ошибка: $e");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Добро пожаловать",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Войдите или создайте аккаунт",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 30),

                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: "Вход"),
                      Tab(text: "Регистрация"),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: TabBarView(
                    children: [
                      _buildLoginForm(),
                      _buildRegisterForm()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            label: "Имя пользователя",
            hint: "Username",
            controller: _loginUsernameController,
            prefixIcon: const Icon(Icons.person_outline),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: "Пароль",
            hint: "Password",
            isPassword: true,
            controller: _loginPasswordController,
            prefixIcon: const Icon(Icons.lock_outline),
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: "Войти",
            isLoading: _isLoading, // Показываем индикатор загрузки
            onTap: _handleLogin,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            label: "Имя пользователя",
            hint: "Username",
            controller: _regUsernameController,
            prefixIcon: const Icon(Icons.person_outline),
          ),
          const SizedBox(height: 20),
           // --- НОВОЕ ПОЛЕ: ТЕЛЕФОН ---
          CustomTextField(
            label: "Номер телефона",
            hint: "+77771234567",
            controller: _regPhoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: "Пароль",
            hint: "Password",
            isPassword: true,
            controller: _regPasswordController,
            prefixIcon: const Icon(Icons.lock_outline),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: "Подтвердите пароль",
            hint: "Confirm Password",
            isPassword: true,
            controller: _regConfirmPasswordController,
            prefixIcon: const Icon(Icons.lock_outline),
          ),
          const SizedBox(height: 40),
          CustomButton(
            text: "Зарегистрироваться",
            backgroundColor: Colors.black,
            isLoading: _isLoading, // Показываем индикатор загрузки
            onTap: _handleRegister,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}