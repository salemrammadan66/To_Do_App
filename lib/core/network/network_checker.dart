import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class NetworkChecker {
  static Future<bool> hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.isEmpty ||
        connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    try {
      final result = await http
          .get(Uri.parse('https://google.com'))
          .timeout(const Duration(seconds: 5));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Emits `true` whenever the device regains connectivity (Wi-Fi/mobile/etc.),
  /// and `false` when it loses it. Used to trigger an automatic sync of
  /// pending offline changes as soon as the connection comes back.
  static Stream<bool> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged.map(
      (results) =>
          !(results.isEmpty || results.contains(ConnectivityResult.none)),
    );
  }
}
