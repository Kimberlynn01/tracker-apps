// import 'package:course_udemy_expense_tracker_app/models/register.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RegisterMd extends StatefulWidget {
  RegisterMd(
      {super.key,
      required this.usernameController,
      required this.emailController,
      required this.passwordController});
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  State<RegisterMd> createState() => _RegisterMdState();
}

class _RegisterMdState extends State<RegisterMd> {
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(35),
        ),
        color: Theme.of(context).primaryColorLight,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 28,
          ),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'T',
                  style: TextStyle(
                    color: Color(0xff7C4DFF),
                    fontSize: 30,
                    fontFamily: 'InknutAntiqua',
                  ),
                ),
                TextSpan(
                  text: 'racker Apps',
                  style: TextStyle(fontSize: 30, fontFamily: 'InknutAntiqua'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            'Register In Here!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'InknutAntiqua',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: widget.usernameController,
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: widget.emailController,
                  cursorColor: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Password',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: widget.passwordController,
                  cursorColor: Colors.white,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: togglePasswordVisibility,
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
