import 'package:dental_case_matching_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows login screen first', (WidgetTester tester) async {
    await tester.pumpWidget(const DentalCaseMatchingApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });
}
