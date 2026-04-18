import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preloved_market/main.dart';

void main() {
  testWidgets('App launches and shows HomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
