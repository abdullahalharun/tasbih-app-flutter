// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_tasbih/main.dart';

void main() {
  testWidgets('Islamic Tasbih app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const IslamicTasbihApp());

    // Verify that the app starts with a tasbih counter
    expect(find.text('Islamic Tasbih'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // Tap the counter button and trigger a frame.
    await tester.tap(find.text('TAP TO COUNT'));
    await tester.pump();

    // Verify that the counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
