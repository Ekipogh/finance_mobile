import 'package:flutter/material.dart';

import '../category.dart';
import '../expense.dart';
import 'monthlyReportScreen.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Expense> expenses;
  final List<Category> categories;

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
        )
    );
  }
}
