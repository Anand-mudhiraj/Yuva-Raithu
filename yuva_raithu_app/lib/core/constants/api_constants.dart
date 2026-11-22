import 'dart:io';

class ApiConstants {
  // Support compile-time configuration via --dart-define=API_URL=http://<ip>:8080/api
  static const String _envUrl = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_envUrl.isNotEmpty) {
      return _envUrl;
    }
    // Base server URL without /api (interceptor guarantees /api prefix)
    return 'http://127.0.0.1:8080';
  }
  
  static const String loginEndpoint = '/auth/signin';
  static const String signupEndpoint = '/auth/signup';
}
