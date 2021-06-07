import 'package:finance_mobile/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:finance_mobile/models/expenseCategory.dart';

import 'homeWidget.dart';

class FinanceApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  List<ExpenseCategory> categories;
  List<Expense> expenses;

  _FinanceAppState() {
    categories = [
      ExpenseCategory(name: "Groceries"),
      ExpenseCategory(name: "Taxi"),
      ExpenseCategory(name: "Drinks"),
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
