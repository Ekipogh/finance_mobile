import 'package:finance_mobile/models/expense.dart';
import 'package:finance_mobile/models/expenseCategory.dart';
import 'package:finance_mobile/screens/monthlyReportScreen.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Expense> expenses;
  final List<ExpenseCategory> categories;

  StatisticsScreen({this.expenses, this.categories});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.assessment),
                  text: "Graphs",
                ),
                Tab(
                  icon: Icon(Icons.today),
                  text: "Monthly report",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Text("Graphs"),
              ),
              MonthlyReportScreen(expenses: expenses, categories: categories),
            ],
          ),
        ));
  }
}
