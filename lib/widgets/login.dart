// ignore_for_file: unrelated_type_equality_checks, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:course_udemy_expense_tracker_app/models/login.dart';
import 'package:course_udemy_expense_tracker_app/widgets/expenses.dart';
import 'package:course_udemy_expense_tracker_app/widgets/login/login_modal.dart';
import 'package:course_udemy_expense_tracker_app/widgets/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../functions/service/login/login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  void _login() async {
    final String enteredUsername = usernameController.text;
    final String enteredPassword = passwordController.text;

    LoginModels model = LoginModels(
        username: enteredUsername, password: enteredPassword, email: '');
    String? userId = await _firebaseService.loginUser(model);

    if (userId != null) {
      print('Login Success');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('username', enteredUsername);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Expenses(),
        ),
        (route) => false,
      );
    } else {
      print('Login Failed');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Username or password is incorrect.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showRegisterDialog();
                },
                child: const Icon(Icons.close),
              ),
            ],
          );
        },
      );
    }
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Don\'t have an account?'),
          content: const Text('Want to create a new account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const RegisterAccount(),
                    ),
                    (route) => false);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/img/pattern_login.png',
                  alignment: Alignment.topCenter,
                  color: Theme.of(context).canvasColor,
                ),
              ),
              Positioned.fill(
                top: 220,
                child: LoginModal(
                  onLoginPressed: _login,
                  usernameController: usernameController,
                  passwordController: passwordController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
