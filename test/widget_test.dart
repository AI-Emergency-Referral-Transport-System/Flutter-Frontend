import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_frontend/main.dart';

void main() {
  testWidgets('Derash boots to splash', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(DerashApp(prefs: prefs));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.textContaining('Derash'), findsWidgets);
  });
}
