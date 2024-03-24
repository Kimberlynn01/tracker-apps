import 'package:flutter/material.dart';

class LoginModal extends StatefulWidget {
  const LoginModal(
      {super.key,
      required this.onLoginPressed,
      required this.passwordController,
      required this.usernameController});

  final VoidCallback onLoginPressed;

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
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
            'Reminder ur day!',
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
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 26),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width, 60),
                    ),
                  ),
                  onPressed: () {
                    widget.onLoginPressed();
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
