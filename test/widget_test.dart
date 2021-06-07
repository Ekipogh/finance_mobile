import 'package:date_field/date_field.dart';
import 'package:finance_mobile/screens/financeApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


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
  });
  testWidgets('Test adding new Expense', (WidgetTester tester) async {
    await tester.pumpWidget(FinanceApp());
    await tester.tap(find.byKey(Key("expenseFloatingButton")));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(Key("expenseAmountField")), "1234567");
    await tester.tap(find.byKey(Key("saveExpenseButton")));
    await tester.pumpAndSettle();
    expect(find.text("1234567.0 R", skipOffstage: false), findsOneWidget);
  });
  testWidgets("Test drawer", (WidgetTester tester) async {
    await tester.pumpWidget(FinanceApp());
    expect(find.text("Profile"), findsNothing);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text("Profile"), findsOneWidget);
  });
  testWidgets("Test new Category Screen", (WidgetTester tester) async {
    await tester.pumpWidget(FinanceApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("CategoryDrawerTile")));
    await tester.pumpAndSettle();
    await tester
        .tap(find.byKey(Key("categoryFloatingButton"), skipOffstage: false));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("newCategoryNameField")), "foobar");
    await tester.tap(find.byKey(Key("saveCategoryButton")));
    expect(find.text("foobar"), findsOneWidget);
  });
  testWidgets("Test statistics", (WidgetTester tester) async {
    await tester.pumpWidget(FinanceApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("StatisticsButton")));
    await tester.pumpAndSettle();
    expect(find.byType(Tab), findsNWidgets(2));
  });
}
