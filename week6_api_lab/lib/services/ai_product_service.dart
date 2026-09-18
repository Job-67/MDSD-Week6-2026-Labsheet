import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const _baseUrl = 'https://fakestoreapi.com/products';
const _timeout = Duration(seconds: 10);

class AiProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  const AiProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }

  @override
  String toString() => 'AiProduct(#$id, $title, \$$price, $category)';
}

Future<List<AiProduct>> fetchAiProducts() {
  return _guard(() async {
    final response = await http.get(Uri.parse(_baseUrl)).timeout(_timeout);
    _checkStatus(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => AiProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  });
}

Future<AiProduct> fetchAiProductById(int id) {
  return _guard(() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/$id')).timeout(_timeout);
    _checkStatus(response);
    // Fake Store API ตอบ 200 พร้อม body ว่างเมื่อไม่พบ id ที่ขอ
    if (response.body.trim().isEmpty) {
      throw Exception('ไม่พบสินค้ารหัส $id');
    }
    return AiProduct.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  });
}

void _checkStatus(http.Response response) {
  if (response.statusCode == 404) {
    throw Exception('ไม่พบข้อมูลสินค้าที่ต้องการ');
  }
  if (response.statusCode != 200) {
    throw Exception('เซิร์ฟเวอร์ขัดข้อง (รหัส ${response.statusCode}) กรุณาลองใหม่ภายหลัง');
  }
}

Future<T> _guard<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on TimeoutException {
    // ดักแยกเพราะ .timeout() โยน TimeoutException เมื่อรอเกิน 10 วินาที
    // ถ้าไม่ดักไว้ ผู้ใช้จะเห็นข้อความภาษาอังกฤษจากระบบที่อ่านไม่เข้าใจ
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // เกิดเมื่อเชื่อมต่อเซิร์ฟเวอร์ไม่ได้เลย เช่น ไม่มีอินเทอร์เน็ต หรือ DNS ล้มเหลว
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // jsonDecode โยน FormatException เมื่อ body ไม่ใช่ JSON ที่ถูกต้อง (เช่น หน้า HTML error)
    throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่อยู่ในรูปแบบที่ถูกต้อง');
  }
}
