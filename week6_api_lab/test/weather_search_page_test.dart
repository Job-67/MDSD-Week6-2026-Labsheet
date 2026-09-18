import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:week6_api_lab/screens/weather_search_page.dart';
import 'package:week6_api_lab/services/weather_service.dart';

const _bangkokJson = '{"name":"กรุงเทพมหานคร",'
    '"main":{"temp":31.5,"feels_like":38.5},'
    '"weather":[{"description":"เมฆกระจาย"}],"cod":200}';

// Checkpoint 2.3 — 3 สถานการณ์: เมืองที่มีจริง / เมืองที่ไม่มีจริง / ไม่มีอินเทอร์เน็ต
void main() {
  Future<void> searchWith(WidgetTester tester, MockClient client, String city) async {
    await tester.pumpWidget(MaterialApp(
      home: WeatherSearchPage(
        weatherService: WeatherService(apiKey: 'test', client: client),
      ),
    ));
    await tester.enterText(find.byType(TextField), city);
    await tester.tap(find.text('ค้นหา'));
    await tester.pumpAndSettle();
  }

  testWidgets('(1) เมืองที่มีจริง แสดงชื่อเมือง อุณหภูมิ คำอธิบาย', (tester) async {
    final client = MockClient((_) async => http.Response.bytes(
          utf8.encode(_bangkokJson),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ));
    await searchWith(tester, client, 'Bangkok');

    expect(find.text('กรุงเทพมหานคร: 31.5°C'), findsOneWidget);
    expect(find.text('เมฆกระจาย'), findsOneWidget);
  });

  testWidgets('(2) เมืองที่ไม่มีจริง แสดงข้อความ error สีแดง', (tester) async {
    final client = MockClient(
        (_) async => http.Response('{"cod":"404","message":"city not found"}', 404));
    await searchWith(tester, client, 'NotARealCity123');

    final text = tester.widget<Text>(
        find.text('ไม่พบเมือง "NotARealCity123" กรุณาตรวจสอบชื่อเมืองอีกครั้ง'));
    expect(text.style?.color, Colors.red);
  });

  testWidgets('(3) ไม่มีอินเทอร์เน็ต แสดงข้อความให้ตรวจสอบการเชื่อมต่อ', (tester) async {
    final client = MockClient(
        (_) async => throw http.ClientException('Failed host lookup'));
    await searchWith(tester, client, 'Bangkok');

    expect(find.text('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ'),
        findsOneWidget);
  });
}
