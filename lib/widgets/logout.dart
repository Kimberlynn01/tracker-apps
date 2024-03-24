import 'package:course_udemy_expense_tracker_app/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  void initState() {
    super.initState();
    logout();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (ctx) => Login(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
