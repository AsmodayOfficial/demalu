import 'package:demalu/core/color_log.dart';
import 'package:demalu/ui/widgets/custom_button.dart';
import 'package:demalu/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginUsernameController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _regUsernameController = TextEditingController();
  final _regPasswordController = TextEditingController();
  final _regConfirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _loginUsernameController.dispose();
    _loginPasswordController.dispose();
    _regUsernameController.dispose();
    _regPasswordController.dispose();
    _regConfirmPasswordController.dispose();
    super.dispose();
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
                    children: [_buildLoginForm(), _buildRegisterForm()],
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
            onTap: () {
              colorLog("Login clicked", color: 'green');
            },
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
            onTap: () {
              colorLog("Register clicked", color: 'green');
            },
          ),
        ],
      ),
    );
  }
}
