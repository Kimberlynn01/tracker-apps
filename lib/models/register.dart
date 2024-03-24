import 'package:uuid/uuid.dart';

const uuid = Uuid();

class RegisterModels {
  RegisterModels(
      {required this.username, required this.email, required this.password})
      : id = uuid.v4();

  final String username;
  final String email;
  final String password;
  final String id;
}
