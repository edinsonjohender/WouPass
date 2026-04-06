import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woupassv2/app/app.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: WouPassApp()),
    );

    expect(find.text('WouPass'), findsOneWidget);
    expect(find.text('Zero-knowledge password manager'), findsOneWidget);
  });
}
