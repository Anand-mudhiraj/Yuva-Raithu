import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yuva_raithu_app/core/network/api_client.dart';
import 'package:yuva_raithu_app/features/auth/data/auth_repository.dart';
import 'package:yuva_raithu_app/features/auth/presentation/auth_notifier.dart';

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final dioProvider = Provider((ref) => Dio());

final apiClientProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(dio, secureStorage);
});

final authRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
