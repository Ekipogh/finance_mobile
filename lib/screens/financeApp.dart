import 'package:flutter/material.dart';

import '../category.dart';
import '../expense.dart';
import 'homeWidget.dart';

class FinanceApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  List<Category> categories;
  List<Expense> expenses;

  _FinanceAppState() {
    categories = [
      Category("Groceries"),
      Category("Taxi"),
      Category("Drinks"),
    ];
    expenses = [
      Expense(DateTime(2021, 05, 19), categories[0], 300),
      Expense(DateTime(2021, 05, 18), categories[1], 500),
      Expense(DateTime(2021, 05, 17), categories[2], 600)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[300],
      ),
      home: HomeWidget(
          expenses: expenses, categories: categories, callback: updateExpenses),
    );
  }

  void updateExpenses(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }
}
