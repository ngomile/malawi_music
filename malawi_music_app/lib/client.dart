import 'package:http/http.dart' as http;

class Client {
  static http.Client? _client;

  static http.Client? client() {
    _client ??= http.Client();

    return _client;
  }
}
