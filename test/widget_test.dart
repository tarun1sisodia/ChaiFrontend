import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chai_frontend/main.dart';

void main() {
  testWidgets('App loads without error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
