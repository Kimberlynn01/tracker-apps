// ignore_for_file: avoid_print

import 'package:course_udemy_expense_tracker_app/models/login.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<String?> loginUser(LoginModels model) async {
    try {
      DatabaseEvent event = await _database
          .child('users')
          .orderByChild('username')
          .equalTo(model.username)
          .once();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> users =
            event.snapshot.value as Map<dynamic, dynamic>;

        String? userId;

        users.forEach((key, value) {
          if (value['password'] == model.password) {
            userId = key.toString();
          }
        });

        return userId;
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
