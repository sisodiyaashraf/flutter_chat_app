import 'package:flutter/foundation.dart';
import '../../../../core/local_storage.dart';

/// Holds session‑level information such as the logged‑in username and server URL.
/// This provider is lightweight and will later be persisted with shared_preferences.
class SessionProvider extends ChangeNotifier {
  String? _username;
  String? _serverUrl;
  bool _rememberMe = false;

  String? get username => _username;
  String? get serverUrl => _serverUrl;
  bool get rememberMe => _rememberMe;

  /// Initialize the provider by loading persisted values.
  Future<void> init() async {
    await LocalStorage.init();
    _username = LocalStorage.getString('username');
    _serverUrl = LocalStorage.getString('serverUrl');
    _rememberMe = LocalStorage.getBool('rememberMe');
    notifyListeners();
  }

  Future<void> setUsername(String username) async {
    if (_username != username) {
      _username = username;
      await LocalStorage.setString('username', username);
      notifyListeners();
    }
  }

  Future<void> setServerUrl(String url) async {
    if (_serverUrl != url) {
      _serverUrl = url;
      await LocalStorage.setString('serverUrl', url);
      notifyListeners();
    }
  }

  Future<void> setRememberMe(bool value) async {
    if (_rememberMe != value) {
      _rememberMe = value;
      await LocalStorage.setBool('rememberMe', value);
      notifyListeners();
    }
  }

}
