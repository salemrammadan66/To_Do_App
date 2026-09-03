import 'auth_local_data_source.dart';
import 'auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepository(this.remote, this.local);

  Future<void> login(String email, String password) async {
    final token = await remote.login(email, password);
    await local.saveToken(token);
  }

  String? getToken() {
    return local.getToken();
  }

  Future<void> logout() async {
    await local.logout();
  }
}