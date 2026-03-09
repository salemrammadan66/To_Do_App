import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/auth_response_model.dart';

class AuthService {
  final String baseUrl = "https://todo-backend-oob0.onrender.com";

  Future<AuthResponseModel> login(String email, String password) async {
    final loginUrl = Uri.parse("$baseUrl/api/auth/login");

    final response = await http.post(
      loginUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthResponseModel.fromJson(data);
    } else {
      throw Exception("Login Failed");
    }
  }

  Future<AuthResponseModel> register(
    String name,
    String email,
    String password,
  ) async {
    final loginUrl = Uri.parse("$baseUrl/api/auth/register");

    final response = await http.post(
      loginUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthResponseModel.fromJson(data);
    } else {
      throw Exception("Register Failed");
    }
  }
}
