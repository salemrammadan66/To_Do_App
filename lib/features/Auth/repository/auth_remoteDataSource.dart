import '../service/auth_service.dart';

class AuthRemoteDataSource {
  final AuthService  api;

  AuthRemoteDataSource(this.api);

  Future<String> login(String email, String password) async {
    final response = await api.login(email, password);
    return response.token;
  }
}