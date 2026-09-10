import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../errors/failure.dart';

class ApiClient {
  String? _token;

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    if (_token != null) "Authorization": "Bearer $_token",
  };

  Future<Map<String, dynamic>> get(String url) =>
      _send(() => http.get(Uri.parse(url), headers: _headers));

  Future<List<dynamic>> getList(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        return decoded is List ? decoded : [];
      }

      Map<String, dynamic> data = {};
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) data = decoded;
      } catch (_) {}

      final message =
          data["message"]?.toString() ??
          data["error"]?.toString() ??
          "Request failed (status code: ${response.statusCode})";
      throw ServerFailure(message);
    } on SocketException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const NetworkFailure(
        "The server isn't responding, check your internet connection",
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  Future<Map<String, dynamic>> post(String url, {Map<String, dynamic>? body}) =>
      _send(
        () => http.post(
          Uri.parse(url),
          headers: _headers,
          body: body != null ? jsonEncode(body) : null,
        ),
      );

  Future<Map<String, dynamic>> put(String url, {Map<String, dynamic>? body}) =>
      _send(
        () => http.put(
          Uri.parse(url),
          headers: _headers,
          body: body != null ? jsonEncode(body) : null,
        ),
      );

  Future<Map<String, dynamic>> delete(String url) =>
      _send(() => http.delete(Uri.parse(url), headers: _headers));

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request().timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const NetworkFailure(
        "The server isn't responding, check your internet connection",
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> data = {};

    try {
      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) data = decoded;
      }
    } catch (_) {
      // Response isn't JSON (e.g. an HTML page if the server is down/suspended).
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    final message =
        data["message"]?.toString() ??
        data["error"]?.toString() ??
        "Request failed (status code: ${response.statusCode})";
    throw ServerFailure(message);
  }
}
