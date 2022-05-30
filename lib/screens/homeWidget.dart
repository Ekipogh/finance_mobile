import 'package:finance_mobile/models/expense.dart';
import 'package:flutter/material.dart';

import 'categoryScreen.dart';
import 'newExpenseScreen.dart';
import 'statisticsScreen.dart';

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: Expense.list(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(children: [
                for (var expense in snapshot.data) _expenseTile(expense)
              ]);
            } else {
              return Center(
                child:
                    Text("Start adding new expenses by pressing Plus button"),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        key: Key("expenseFloatingButton"),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewExpenseScreen(
              callback: callback,
            );
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
                  return StatisticsScreen();
                }));
              },
            )
          ],
        ),
      ),
    );
  }

  Function callback() {
    setState(() {});
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
