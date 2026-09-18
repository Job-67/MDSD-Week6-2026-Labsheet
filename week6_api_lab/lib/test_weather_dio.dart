import 'config/local_key_loader.dart';
import 'services/weather_service_dio.dart';

// รันได้เลย: dart run lib/test_weather_dio.dart (อ่าน key จาก dart_defines.local.json)
Future<void> main() async {
  final weather =
      await fetchWeatherWithDio('Bangkok', apiKey: loadOpenWeatherApiKey());

  print('cityName: ${weather.cityName}');
  print('temperature: ${weather.temperature}');
  print('description: ${weather.description}');
  print('feelsLike: ${weather.feelsLike}');
}
