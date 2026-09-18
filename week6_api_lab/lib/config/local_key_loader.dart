import 'dart:convert';
import 'dart:io';

import 'api_config.dart';

/// ใช้เฉพาะไฟล์ทดสอบที่รันด้วย `dart run` (ไม่ใช่ในแอป Flutter)
///
/// ถ้าไม่ได้ส่ง -DOPENWEATHER_API_KEY มา จะอ่าน key จากไฟล์ dart_defines.local.json
/// (ไฟล์นี้อยู่ใน .gitignore จึงไม่ถูก commit ขึ้น GitHub)
String loadOpenWeatherApiKey() {
  if (openWeatherApiKey != 'YOUR_API_KEY') return openWeatherApiKey;

  final candidates = [
    File('dart_defines.local.json'),
    File.fromUri(Platform.script.resolve('../dart_defines.local.json')),
  ];
  for (final file in candidates) {
    if (file.existsSync()) {
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      return json['OPENWEATHER_API_KEY'] as String;
    }
  }
  throw Exception('ไม่พบ API Key — สร้างไฟล์ dart_defines.local.json หรือรันด้วย -DOPENWEATHER_API_KEY=...');
}
