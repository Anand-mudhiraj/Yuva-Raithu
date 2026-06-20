import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_raithu_app/features/weather/data/weather_repository.dart';

final weatherDioProvider = Provider((ref) {
  return Dio();
});

final weatherRepositoryProvider = Provider((ref) {
  final dio = ref.watch(weatherDioProvider);
  return WeatherRepository(dio);
});

final weatherProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(weatherRepositoryProvider);
  return repository.getWeather();
});
