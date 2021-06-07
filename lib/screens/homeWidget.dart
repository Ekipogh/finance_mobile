import 'package:finance_mobile/models/expense.dart';
import 'package:finance_mobile/models/expenseCategory.dart';
import 'package:flutter/material.dart';

import 'categoryScreen.dart';
import 'newExpenseScreen.dart';
import 'statisticsScreen.dart';

class HomeWidget extends StatefulWidget {
  final List<Expense> expenses;
  final List<ExpenseCategory> categories;
  final Function callback;

  HomeWidget({this.expenses, this.callback, this.categories});

  @override
  State<StatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [for (var expense in widget.expenses) _expenseTile(expense)],
      ),
      floatingActionButton: FloatingActionButton(
        key: Key("expenseFloatingButton"),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewExpenseScreen(
                callback: widget.callback, categories: widget.categories);
          }));
        },
      ),
      drawer: Drawer(
        key: ValueKey("Drawer"),
        child: ListView(
          children: [
            DrawerHeader(child: Text("Profile")),
            ListTile(
              title: Text("Expenses"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              key: Key("CategoryDrawerTile"),
              title: Text("Categories"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CategoryScreen();
                }));
              },
            ),
            ListTile(
              key: Key("StatisticsButton"),
              title: Text("Statistics"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return StatisticsScreen(
                      expenses: widget.expenses, categories: widget.categories);
                }));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _expenseTile(Expense expense) {
    return ListTile(
      leading: Text(expense.amountStr()),
      title: Text(expense.category.toString()),
      subtitle: Text(expense.dateStr()),
      trailing: Icon(Icons.more_vert),
    );
  }
}
