import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    final response = await http.get(
      Uri.parse('$_baseUrl?q=$city&appid=$apiKey&units=metric'),
    );
    log('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
