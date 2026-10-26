import 'package:flutter/foundation.dart' show kIsWeb;
// dart:io is only available on non-web platforms.
// We guard its usage behind a kIsWeb check so the import is never
// reached at runtime on web.
import 'dart:io' show Platform;

class AppConfig {
  static String serverUrl = _defaultServerUrl();

  static String _defaultServerUrl() {
    if (kIsWeb) {
      // When running as a Flutter web app, default to the same origin.
      return 'http://localhost:5000';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000';
    }
    if (Platform.isIOS) {
      return 'http://127.0.0.1:5000';
    }
    // Desktop (Windows / macOS / Linux)
    return const String.fromEnvironment(
      'SERVER_URL',
      defaultValue: 'http://localhost:5000',
    );
  }
}
