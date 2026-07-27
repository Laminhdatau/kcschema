import 'package:flutter_test/flutter_test.dart';
import 'package:kyaschema/app.dart';

void main() {
  testWidgets('KyaSchemaApp renders without crashing', (tester) async {
    await tester.pumpWidget(const KyaSchemaApp());
    // Verify the app shell renders
    expect(find.text('KYASCHEMA'), findsOneWidget);
  });
}
