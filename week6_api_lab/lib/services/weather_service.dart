import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey = openWeatherApiKey;

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse(
      '$_baseUrl?q=${Uri.encodeQueryComponent(city)}&appid=$_apiKey&units=metric&lang=th',
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      }
      if (response.statusCode == 404) {
        throw Exception('ไม่พบเมือง "$city" กรุณาตรวจสอบชื่อเมืองอีกครั้ง');
      }
      if (response.statusCode == 401) {
        throw Exception('API Key ไม่ถูกต้องหรือยังไม่เปิดใช้งาน');
      }
      throw Exception('เซิร์ฟเวอร์ขัดข้อง (รหัส ${response.statusCode}) กรุณาลองใหม่ภายหลัง');
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่อยู่ในรูปแบบที่ถูกต้อง');
    } catch (e) {
      rethrow;
    }
  }
}
