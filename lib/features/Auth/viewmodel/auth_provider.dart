import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../core/errors/failure.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_checker.dart';
import '../model/user_model.dart';
import '../service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _client;
  late final AuthService _authService;

  bool isLoading = false;
  UserModel? user;
  String? token;
  Failure? failure;

  String? get error => failure?.message;

  AuthProvider(this._client) {
    _authService = AuthService(_client);
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      failure = null;
      notifyListeners();

      final hasConnection = await NetworkChecker.hasInternet();
      if (!hasConnection) throw const NetworkFailure();

      final response = await _authService.login(email, password);

      user = response.user;
      token = response.token;
      _client.setToken(token!);

      final box = await Hive.openBox('authBox');
      await box.put('token', token);
    } on Failure catch (f) {
      failure = f;
    } catch (e) {
      failure = UnknownFailure(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading = true;
      failure = null;
      notifyListeners();

      final hasConnection = await NetworkChecker.hasInternet();
      if (!hasConnection) throw const NetworkFailure();

      final response = await _authService.register(name, email, password);

      user = response.user;
      token = response.token;
      _client.setToken(token!);

      final box = await Hive.openBox('authBox');
      await box.put('token', token);
    } on Failure catch (f) {
      failure = f;
    } catch (e) {
      failure = UnknownFailure(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadToken() async {
    final box = await Hive.openBox('authBox');
    token = box.get('token');
    if (token != null) _client.setToken(token!);
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      failure = null;
      notifyListeners();

      user = await _authService.getProfile();
    } on Failure catch (f) {
      failure = f;
    } catch (e) {
      failure = UnknownFailure(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? password,
  }) async {
    try {
      isLoading = true;
      failure = null;
      notifyListeners();

      user = await _authService.updateProfile(
        name: name,
        email: email,
        password: password,
      );
      return true;
    } on Failure catch (f) {
      failure = f;
      return false;
    } catch (e) {
      failure = UnknownFailure(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final box = await Hive.openBox('authBox');
    await box.delete('token');

    _client.clearToken();
    token = null;
    user = null;
    failure = null;

    notifyListeners();
  }
}
