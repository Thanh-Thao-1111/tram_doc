import 'package:flutter_test/flutter_test.dart';
import 'package:tram_doc/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Kiểm tra app render được (không crash)
    expect(find.byType(MyApp), findsOneWidget);
  });
}
