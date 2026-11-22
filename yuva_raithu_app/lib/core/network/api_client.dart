import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yuva_raithu_app/core/constants/api_constants.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ApiClient(this.dio, this.secureStorage) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Guarantee path is prefixed with /api for backend controllers
        if (!options.path.startsWith('http')) {
          if (!options.path.startsWith('/api')) {
            options.path = '/api${options.path.startsWith('/') ? options.path : '/${options.path}'}';
          }
        }
        // Add Authorization header if token exists
        final token = await secureStorage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle errors centrally if needed
        return handler.next(e);
      },
    ));
  }
}
