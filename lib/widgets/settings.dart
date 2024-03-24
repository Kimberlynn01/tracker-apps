// ignore_for_file: deprecated_member_use, use_super_parameters, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_page/appbar.dart';
import 'settings_page/settings_forms.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? username;
  String? email;
  String? password;

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      _fetchUserData(userId);
    }
  }

  Future<void> _fetchUserData(String userId) async {
    _databaseRef
        .child('users')
        .child(userId)
        .once()
        .then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> userData =
            snapshot.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          username = userData['username'] ?? 'Data Not Found';
          email = userData['email'] ?? 'Data Not Found';
          password = userData['password'] ?? 'Data Not Found';
        });
      } else {
        print('User Not Found');
      }
    }).catchError((error) {
      print('ERROR : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: const AppBarSettings(),
      body: username != null && email != null && password != null
          ? SettingsForms(
              username: username!,
              email: email!,
              password: password!,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
