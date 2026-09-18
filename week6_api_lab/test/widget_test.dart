import 'package:flutter_test/flutter_test.dart';

import 'package:week6_api_lab/main.dart';

void main() {
  testWidgets('WeatherSearchPage shows search field and button', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ค้นหาสภาพอากาศ'), findsOneWidget);
    expect(find.text('ชื่อเมือง'), findsOneWidget);
    expect(find.text('ค้นหา'), findsOneWidget);
  });
}
