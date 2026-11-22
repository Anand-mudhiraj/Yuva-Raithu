import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_raithu_app/main.dart';

void main() {
  testWidgets('Yuva Raithu smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify MyApp mounts successfully
    expect(find.byType(MyApp), findsOneWidget);
  });
}
