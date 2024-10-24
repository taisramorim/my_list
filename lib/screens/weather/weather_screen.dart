import 'package:flutter/material.dart';
import 'package:my_list/services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _temperature = '';
  String _weatherDescription = '';
  String _weatherEmoji = '';
  String _feelsLike = '';
  String _tempMin = '';
  String _tempMax = '';
  String _humidity = '';
  String _windSpeed = '';
  String _errorMessage = '';
  bool _showWeatherCard = false;

  void _fetchWeather() async {
    final weatherService = WeatherService();
    final city = _cityController.text;
    try {
      final data = await weatherService.fetchWeather(city);
      setState(() {
        _temperature = '${data['main']['temp']} °C';
        _weatherDescription = data['weather'][0]['description'];
        _feelsLike = '${data['main']['feels_like']} °C';
        _tempMin = '${data['main']['temp_min']} °C';
        _tempMax = '${data['main']['temp_max']} °C';
        _humidity = '${data['main']['humidity']}%';
        _windSpeed = '${data['wind']['speed']} m/s';
        _errorMessage = '';
        _showWeatherCard = true;

        switch (data['weather'][0]['main']) {
          case 'Clear':
            _weatherEmoji = '☀️';
            break;
          case 'Clouds':
            _weatherEmoji = '☁️';
            break;
          case 'Rain':
            _weatherEmoji = '🌧️';
            break;
          case 'Snow':
            _weatherEmoji = '❄️';
            break;
          case 'Thunderstorm':
            _weatherEmoji = '⛈️';
            break;
          case 'Mist':
            _weatherEmoji = '🌫️';
            break;
          default:
            _weatherEmoji = '🌈';
            break;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Não encontramos a cidade';
        _temperature = '';
        _weatherEmoji = '';
        _feelsLike = '';
        _tempMin = '';
        _tempMax = '';
        _humidity = '';
        _windSpeed = '';
        _showWeatherCard = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Digite a cidade',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _fetchWeather,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: Text('Buscar Clima', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            if (_showWeatherCard)
              Expanded(
                child: Center(
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_weatherEmoji Previsão do Clima',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text('Condições: $_weatherDescription', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 5),
                          Text('Temperatura: $_temperature', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 5),
                          Text('Sensação: $_feelsLike', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 5),
                          Text('Mínima: $_tempMin', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 5),
                          Text('Máxima: $_tempMax', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 5),
                          Text('Umidade: $_humidity', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 5),
                          Text('Vento: $_windSpeed', style: TextStyle(fontSize: 20)),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
