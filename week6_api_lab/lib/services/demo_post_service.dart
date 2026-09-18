import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> createDemoPost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'title': 'ทดสอบส่งข้อมูลจาก Flutter',
      'body': 'นี่คือเนื้อหาที่ส่งด้วย HTTP POST',
      'userId': 1,
    }),
  );

  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}

Future<void> updateDemoPost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'id': 1,
      // TODO: ใส่รหัสและชื่อนักศึกษาของตัวเอง
      'studentId': 'YOUR_STUDENT_ID',
      'studentName': 'YOUR_NAME',
      'title': 'แก้ไขข้อมูลด้วย HTTP PUT',
      'body': 'นี่คือเนื้อหาที่แก้ไขด้วย HTTP PUT',
      'userId': 1,
    }),
  );

  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}
