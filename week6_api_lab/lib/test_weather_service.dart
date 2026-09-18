import 'config/local_key_loader.dart';
import 'services/weather_service.dart';

// Checkpoint 2.2 — ทดสอบ WeatherService (http) กรณีสำเร็จและกรณี 404
// รันได้เลย: dart run lib/test_weather_service.dart (อ่าน key จาก dart_defines.local.json)
Future<void> main() async {
  final service = WeatherService(apiKey: loadOpenWeatherApiKey());

  for (final city in ['Bangkok', 'NotARealCity123']) {
    try {
      final w = await service.fetchWeather(city);
      print('[$city] สำเร็จ: ${w.cityName} ${w.temperature}°C ${w.description}');
    } catch (e) {
      print('[$city] ผิดพลาด: $e');
    }
  }
}
