import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/app.dart';

void main() {
  testWidgets('Nivaas Foundation Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: NivaasApp(),
      ),
    );
    expect(find.byType(NivaasApp), findsOneWidget);
  });
}
