import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../Settings/network_checker.dart';
import '../../tasks/repository/task_RemoteDataSource.dart';
import '../model/user_model.dart';
import '../service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final TaskRemoteDataSource remote;
  final AuthService _authService = AuthService();

  bool isLoading = false;
  UserModel? user;
  String? token;
  String? error;

  AuthProvider(this.remote);

  Future<void> login(String email, String password, TaskRemoteDataSource remote) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final hasConnection = await NetworkChecker.hasInternet();
      if (!hasConnection) throw Exception("No Internet Connection");

      final response = await _authService.login(email, password);

      user = response.user;
      token = response.token;

      remote.setToken(token!);

    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final hasConnection = await NetworkChecker.hasInternet();

      if (!hasConnection) {
        throw Exception("No Internet Connection");
      }

      final response = await _authService.register(name, email, password);

      user = response.user;
      token = response.token;
      final box = await Hive.openBox('authBox');
      await box.put('token', token);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadToken() async {
    final box = await Hive.openBox('authBox');
    token = box.get('token'); // ممكن يكون null لو أول مرة
    notifyListeners();
  }
}
