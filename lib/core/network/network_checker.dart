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
          .timeout(Duration(seconds: 5));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
