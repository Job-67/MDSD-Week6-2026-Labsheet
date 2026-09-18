/// อ่าน API Key จาก --dart-define เพื่อไม่ให้ Key จริงถูก commit ขึ้น GitHub
///
/// flutter run --dart-define=OPENWEATHER_API_KEY=xxxxxxxx
/// dart run -DOPENWEATHER_API_KEY=xxxxxxxx lib/test_weather_dio.dart
const openWeatherApiKey = String.fromEnvironment(
  'OPENWEATHER_API_KEY',
  defaultValue: 'YOUR_API_KEY',
);
