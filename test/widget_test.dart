// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_mobile/main.dart';

void main() {
  testWidgets('Test plus button tapping and New Expense Page appearing',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(FinanceApp());
    expect(find.byType(DateTimeField, skipOffstage: false), findsNothing);
    expect(find.byKey(Key("expenseCategoryDropDown"), skipOffstage: false),
        findsNothing);
    expect(find.byType(TextField, skipOffstage: false), findsNothing);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.byType(DateTimeField, skipOffstage: false), findsOneWidget);
    expect(find.byKey(Key("expenseCategoryDropDown"), skipOffstage: false),
        findsOneWidget);
    expect(find.byType(TextField, skipOffstage: false), findsOneWidget);
    await tester.tap(find.byType(IconButton, skipOffstage: false));
  });
  testWidgets('Test adding new Expense', (WidgetTester tester) async {
    await tester.pumpWidget(FinanceApp());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(Key("expenseCategoryAmountField")), "1234567");
    await tester.tap(find.byKey(Key("saveExpenseButton")));
    await tester.pumpAndSettle();
    expect(find.text("1234567.0 R", skipOffstage: false), findsOneWidget);
  });
}
