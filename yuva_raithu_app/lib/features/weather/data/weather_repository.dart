import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class WeatherRepository {
  final Dio dio;

  WeatherRepository(this.dio);

  Future<Map<String, dynamic>> getWeather() async {
    try {
      // 1. Get Location based on IP
      debugPrint("Fetching location via IP...");
      final locationResponse = await dio.get('http://ip-api.com/json/');
      if (locationResponse.statusCode != 200) {
        throw Exception("Failed to get location");
      }
      final locationData = locationResponse.data;
      final lat = locationData['lat'];
      final lon = locationData['lon'];
      final city = locationData['city'];
      
      debugPrint("Location resolved: $city ($lat, $lon)");

      // 2. Fetch Weather from Open-Meteo
      final weatherUrl = 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto';
      debugPrint("Fetching weather data...");
      final weatherResponse = await dio.get(weatherUrl);
      
      if (weatherResponse.statusCode != 200) {
        throw Exception("Failed to get weather data");
      }
      
      final weatherData = weatherResponse.data;
      return {
        'city': city,
        'current': weatherData['current_weather'],
        'daily': weatherData['daily'],
      };
      
    } catch (e) {
      debugPrint("Error fetching weather: $e");
      throw Exception('Failed to fetch weather: $e');
    }
  }
}
