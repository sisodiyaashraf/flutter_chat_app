import 'dart:io';

class AppConfig {
  // Returns the appropriate server URL based on the current platform.
  // For Android emulator use 10.0.2.2, for iOS simulator use 127.0.0.1, otherwise use a LAN IP.
  static String get serverUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000';
    } else if (Platform.isIOS) {
      return 'http://127.0.0.1:5000';
    } else {
      // Default to localhost; developers can override via environment variable.
      return const String.fromEnvironment(
        'SERVER_URL',
        defaultValue: 'http://localhost:5000',
      );
    }
  }
}
