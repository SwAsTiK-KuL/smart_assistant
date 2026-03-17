import 'package:flutter_test/flutter_test.dart';
import 'package:bharatnxt_app/main.dart';

void main() {
  testWidgets('BharatNxt app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BharatNxtApp());
    expect(find.byType(BharatNxtApp), findsOneWidget);
  });
}
