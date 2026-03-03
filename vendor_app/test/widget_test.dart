import 'package:flutter_test/flutter_test.dart';
import 'package:vendor_app/main.dart';

void main() {
  testWidgets('Vendor app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VendorApp());

    // Verify that vendor app loads
    expect(find.text('Vendor App'), findsOneWidget);
    expect(find.text('Vendor Login'), findsOneWidget);
  });
}
