import 'package:hive/hive.dart';

class AuthLocalDataSource {
  final Box box = Hive.box('auth');

  Future<void> saveToken(String token) async {
    await box.put("token", token);
  }

  String? getToken() {
    return box.get("token");
  }

  Future<void> logout() async {
    await box.delete("token");
  }
}