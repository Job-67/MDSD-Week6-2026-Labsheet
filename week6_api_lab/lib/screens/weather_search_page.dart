import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/ai_product_service.dart';
import '../services/demo_post_service.dart';
import '../services/weather_service.dart';
import '../services/weather_service_dio.dart';

enum _ViewStatus { idle, loading, success, error }

class WeatherSearchPage extends StatefulWidget {
  const WeatherSearchPage({super.key});

  @override
  State<WeatherSearchPage> createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  final _weatherService = WeatherService();
  final _cityController = TextEditingController();

  _ViewStatus _status = _ViewStatus.idle;
  Weather? _weather;
  String? _errorMessage;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() => _status = _ViewStatus.loading);

    try {
      final weather = await _weatherService.fetchWeather(_cityController.text);
      setState(() {
        _weather = weather;
        _status = _ViewStatus.success;
      });
    } catch (e) {
      setState(() {
        _status = _ViewStatus.error;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _testDio() async {
    try {
      final w = await fetchWeatherWithDio(_cityController.text);
      print('cityName: ${w.cityName}');
      print('temperature: ${w.temperature}');
      print('description: ${w.description}');
      print('feelsLike: ${w.feelsLike}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> _testAiProducts() async {
    try {
      final products = await fetchAiProducts();
      products.forEach(print);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ค้นหาสภาพอากาศ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(labelText: 'ชื่อเมือง'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _status == _ViewStatus.loading ? null : _search,
            child: const Text('ค้นหา'),
          ),
          const SizedBox(height: 16),
          if (_status == _ViewStatus.loading)
            const Center(child: CircularProgressIndicator()),
          if (_status == _ViewStatus.success && _weather != null) ...[
            Text(
              '${_weather!.cityName}: ${_weather!.temperature}°C',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(_weather!.description),
            Text('รู้สึกเหมือน ${_weather!.feelsLike}°C'),
          ],
          if (_status == _ViewStatus.error && _errorMessage != null)
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          const Divider(height: 32),
          const Text('ปุ่มทดลอง (ดูผลใน Debug Console)'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => createDemoPost(),
            child: const Text('ทดลอง POST (ขั้นตอนที่ 3.1)'),
          ),
          ElevatedButton(
            onPressed: () => updateDemoPost(),
            child: const Text('ทดลอง PUT (ขั้นตอนที่ 3.2)'),
          ),
          ElevatedButton(
            onPressed: _testAiProducts,
            child: const Text('ทดลอง fetchAiProducts (ขั้นตอนที่ 4.3)'),
          ),
          ElevatedButton(
            onPressed: _testDio,
            child: const Text('ทดลอง Dio (ขั้นตอนที่ 5.3)'),
          ),
        ],
      ),
    );
  }
}
