import 'package:flutter/foundation.dart';

/// Holds session‑level information such as the logged‑in username and server URL.
/// This provider is lightweight and will later be persisted with shared_preferences.
class SessionProvider extends ChangeNotifier {
  String? _username;
  String? _serverUrl;
  bool _rememberMe = false;

  String? get username => _username;
  String? get serverUrl => _serverUrl;
  bool get rememberMe => _rememberMe;

  void setUsername(String username) {
    if (_username != username) {
      _username = username;
      notifyListeners();
    }
  }

  void setServerUrl(String url) {
    if (_serverUrl != url) {
      _serverUrl = url;
      notifyListeners();
    }
  }

  void setRememberMe(bool value) {
    if (_rememberMe != value) {
      _rememberMe = value;
      notifyListeners();
    }
  }
}
