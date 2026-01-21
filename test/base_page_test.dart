import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_pals/presentation/pages/home/home_page.dart';

void main() {
  testWidgets('Pages', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Verify navigation tabs are displayed.
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(find.byIcon(Icons.people_outline), findsOneWidget);
    expect(find.byIcon(Icons.analytics_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });
}
