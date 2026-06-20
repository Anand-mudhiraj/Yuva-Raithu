import 'dart:io';

class ApiConstants {
  // Use 10.0.2.2 for Android emulator to connect to localhost
  // Use localhost or 127.0.0.1 for iOS simulator and Windows
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.92.190.21:8080/api'; // Host Wi-Fi IP for physical device
    } else {
      return 'http://127.0.0.1:8080/api';
    }
  }
  
  static const String loginEndpoint = '/auth/signin';
  static const String signupEndpoint = '/auth/signup';
}
