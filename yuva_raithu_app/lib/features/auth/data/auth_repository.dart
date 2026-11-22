import 'package:flutter/foundation.dart';
import 'package:yuva_raithu_app/core/constants/api_constants.dart';
import 'package:yuva_raithu_app/core/network/api_client.dart';
import 'package:yuva_raithu_app/features/auth/domain/user.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);

  Future<User?> login(String phoneNumber, String password) async {
    try {
      debugPrint('[AuthRepository] Attempting login for phone: $phoneNumber to ${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}');
      final response = await apiClient.dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      debugPrint('[AuthRepository] Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint('[AuthRepository] Login success data: $data');
        // Save Token securely
        await apiClient.secureStorage.write(key: 'jwt_token', value: data['token']);
        
        // Return User domain object
        final user = User.fromJson(data);
        debugPrint('[AuthRepository] Parsed user: ${user.fullName}, ID: ${user.id}');
        return user;
      }
    } catch (e, stack) {
      debugPrint('[AuthRepository] Login error: $e\n$stack');
      throw Exception('Failed to login: $e');
    }
    return null;
  }

  Future<bool> signup(String fullName, String phoneNumber, String password) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.signupEndpoint,
        data: {
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception('Failed to signup: $e');
    }
    return false;
  }

  Future<void> logout() async {
    await apiClient.secureStorage.delete(key: 'jwt_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await apiClient.secureStorage.read(key: 'jwt_token');
    return token != null;
  }

  Future<User?> getUserProfile() async {
    try {
      final response = await apiClient.dio.get('/auth/me');
      if (response.statusCode == 200 && response.data != null) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      // Catch network or parsing errors and return null
      return null;
    }
  }
}
