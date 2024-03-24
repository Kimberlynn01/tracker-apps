// ignore_for_file: deprecated_member_use, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsForms extends StatefulWidget {
  final String username;
  final String email;
  final String password;

  const SettingsForms({
    super.key,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  State<SettingsForms> createState() => _SettingsFormsState();
}

class _SettingsFormsState extends State<SettingsForms> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController oldPasswordController;
  bool _isVisivblePasswordOld = false;
  bool _isVisivblePasswordNew = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();

  void togglePasswordVisibilityOld() {
    setState(() {
      _isVisivblePasswordOld = !_isVisivblePasswordOld;
    });
  }

  void togglePasswordVisibilityNew() {
    setState(() {
      _isVisivblePasswordNew = !_isVisivblePasswordNew;
    });
  }

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController();
    oldPasswordController = TextEditingController();
  }

  Future<void> _updateUserData() async {
    try {
      String userId =
          await _getUserId(); // Mendapatkan userId dari SharedPreferences

      String currentPassword = await _getCurrentPasswordFromDatabase(userId);

      String oldPassword = oldPasswordController.text;
      String newPassword = passwordController.text;

      bool isOldPasswordValid = oldPassword == currentPassword;
      if (!isOldPasswordValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Old password is incorrect')),
        );
        return;
      }

      // Update username, email, and password in database
      await _databaseRef.child('users').child(userId).update({
        'username': usernameController.text,
        'email': emailController.text,
        'password': newPassword,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user data: $error')),
      );
    }
  }

  Future<String> _getCurrentPasswordFromDatabase(String userId) async {
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    String currentPassword = '';

    await databaseRef
        .child('users')
        .child(userId)
        .child('password')
        .once()
        .then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        currentPassword = snapshot.snapshot.value.toString();
      }
    }).catchError((error) {
      print('Error getting current password: $error');
    });

    return currentPassword;
  }

  Future<String> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  Future<bool> checkOldPassword(String oldPassword) async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height + 40,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('assets/img/userCircle.png'),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
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
                  TextFormField(
                    controller: usernameController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
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
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Password',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: passwordController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    obscureText: !_isVisivblePasswordNew,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: togglePasswordVisibilityNew,
                        icon: Icon(
                          _isVisivblePasswordNew
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Old Password',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: oldPasswordController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    obscureText: !_isVisivblePasswordOld,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: togglePasswordVisibilityOld,
                          icon: Icon(
                            _isVisivblePasswordOld
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          )),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 26),
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
                    onPressed: _updateUserData,
                    child: const Text(
                      'Update',
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
      ),
    );
  }
}
