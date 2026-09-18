import 'services/ai_product_service.dart';

Future<void> main() async {
  final products = await fetchAiProducts();
  print('ได้สินค้าทั้งหมด ${products.length} รายการ');
  for (final p in products) {
    print(p);
  }

  final first = await fetchAiProductById(1);
  print('fetchAiProductById(1): $first');
}
