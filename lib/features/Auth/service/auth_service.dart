import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../model/auth_response_model.dart';
import '../model/user_model.dart';

class AuthService {
  final ApiClient _client;

  AuthService(this._client);

  static const bool useMockAuth = false;

  AuthResponseModel _mockAuthResponse(String email, {String? name}) {
    final now = DateTime.now().toIso8601String();
    return AuthResponseModel(
      user: UserModel(
        id: "mock-user-id",
        name: name ?? "Test User",
        email: email,
        createdAt: now,
        updatedAt: now,
      ),
      token: "mock-token",
    );
  }

  Future<AuthResponseModel> login(String email, String password) async {
    if (useMockAuth) {
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockAuthResponse(email);
    }

    final data = await _client.post(
      ApiConstants.loginEndpoint,
      body: {"email": email, "password": password},
    );
    return AuthResponseModel.fromJson(data);
  }

  Future<AuthResponseModel> register(
    String name,
    String email,
    String password,
  ) async {
    if (useMockAuth) {
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockAuthResponse(email, name: name);
    }

    final data = await _client.post(
      ApiConstants.registerEndpoint,
      body: {"name": name, "email": email, "password": password},
    );
    return AuthResponseModel.fromJson(data);
  }

  Future<UserModel> getProfile() async {
    final data = await _client.get(ApiConstants.meEndpoint);
    return UserModel.fromJson(data);
  }

  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? password,
  }) async {
    final body = <String, dynamic>{};
    if (name != null && name.isNotEmpty) body['name'] = name;
    if (email != null && email.isNotEmpty) body['email'] = email;
    if (password != null && password.isNotEmpty) body['password'] = password;

    final data = await _client.put(ApiConstants.meEndpoint, body: body);
    return UserModel.fromJson(data);
  }
}
