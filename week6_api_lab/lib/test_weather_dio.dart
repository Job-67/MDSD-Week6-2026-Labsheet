import 'services/weather_service_dio.dart';

// dart run -DOPENWEATHER_API_KEY=xxxxxxxx lib/test_weather_dio.dart
Future<void> main() async {
  final weather = await fetchWeatherWithDio('Bangkok');

  print('cityName: ${weather.cityName}');
  print('temperature: ${weather.temperature}');
  print('description: ${weather.description}');
  print('feelsLike: ${weather.feelsLike}');
}
