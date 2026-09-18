import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:campus_marketplace/main.dart';
import 'package:campus_marketplace/models/favorites_model.dart';

void main() {
  testWidgets('HomePage shows app title and saved count', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => FavoritesModel(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Campus Marketplace'), findsOneWidget);
    expect(find.text(' 0'), findsOneWidget);
  });
}
