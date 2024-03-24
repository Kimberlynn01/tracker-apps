// ignore_for_file: avoid_print, deprecated_member_use

import 'package:course_udemy_expense_tracker_app/models/register.dart';
import 'package:course_udemy_expense_tracker_app/widgets/login.dart';
import 'package:course_udemy_expense_tracker_app/widgets/registerAccount/register_md.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key});

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> checkUsernameAndEmailUniqueness(
      String username, String email) async {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    // Cek keunikan username
    DatabaseEvent usernameSnapshot = await databaseReference
        .child('users')
        .orderByChild('username')
        .equalTo(username)
        .once();

    // Cek keunikan email
    DatabaseEvent emailSnapshot = await databaseReference
        .child('users')
        .orderByChild('email')
        .equalTo(email)
        .once();

    return usernameSnapshot.snapshot.value == null &&
        emailSnapshot.snapshot.value == null;
  }

  void sendToDatabase(RegisterModels model) async {
    final databaseReference = FirebaseDatabase.instance.ref();
    String username = model.username;
    String email = model.email;

    if (await checkUsernameAndEmailUniqueness(username, email)) {
      databaseReference.child('users').child(model.id).set({
        'username': model.username,
        'email': model.email,
        'password': model.password,
      }).then((_) {
        print(
            'berhasil menambahkan user ${model.username} email : ${model.email} password : ${model.password}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Success',
              ),
              content: Text('add account ${model.username}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const Login(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Icon(Icons.close),
                ),
              ],
            );
          },
        );
      });
    } else {
      return showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Failed!'),
              content: const Text('Username / Email already exists'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: MediaQuery.of(context).size.height + 100,
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
                top: 190,
                child: RegisterMd(
                  usernameController: usernameController,
                  emailController: emailController,
                  passwordController: passwordController,
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 26),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 60),
                      ),
                    ),
                    onPressed: () {
                      RegisterModels model = RegisterModels(
                        username: usernameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      sendToDatabase(model);
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
