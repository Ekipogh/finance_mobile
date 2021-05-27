import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'expense.dart';
import 'category.dart';

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  List<Expense> expenses = [
    Expense(DateTime(2021, 05, 19), Category("Groceries"), 300),
    Expense(DateTime(2021, 05, 18), Category("Taxi"), 500),
    Expense(DateTime(2021, 05, 17), Category("Drinks"), 600)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[300],
      ),
      home: HomeWidget(expenses: expenses, callback: updatePage),
    );
  }

  updatePage(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }
}

class HomeWidget extends StatefulWidget {
  final List<Expense> expenses;
  final Function callback;

  HomeWidget({this.expenses, this.callback});

  @override
  State<StatefulWidget> createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [for (var expense in widget.expenses) _expenseTile(expense)],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewExpenseScreen(callback: widget.callback);
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
              title: Text("Monthly Report"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return MonthlyReportScreen();
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

class NewExpenseScreen extends StatefulWidget {
  final Function callback;

  NewExpenseScreen({this.callback});

  @override
  State<StatefulWidget> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  DateTime _date;
  final List<Category> categories = [
    Category("Groceries"),
    Category("Taxi"),
    Category("Drinks")
  ];
  Category _selectedCategory;
  String _amount;

  _NewExpenseScreenState() {
    this._date = DateTime.now();
    this._selectedCategory = categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
              key: Key("saveExpenseButton"),
              onPressed: () {
                Expense expense =
                    Expense(_date, _selectedCategory, double.parse(_amount));
                widget.callback(expense);
                Navigator.of(context).pop();
              },
              child: Text("Save"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "New expense",
              style: Theme.of(context).textTheme.headline6,
            ),
            Container(
              height: 60,
              child: DateTimeFormField(
                initialValue: _date,
                onDateSelected: (value) {
                  setState(() {
                    _date = value;
                  });
                },
                mode: DateTimeFieldPickerMode.date,
              ),
            ),
            Container(
              height: 60,
              child: DropdownButtonFormField(
                key: Key("expenseCategoryDropDown"),
                value: _selectedCategory,
                onChanged: (Category newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: categories
                    .map<DropdownMenuItem<Category>>((Category value) {
                  return DropdownMenuItem<Category>(
                      value: value, child: Text(value.toString()));
                }).toList(),
              ),
            ),
            TextField(
              key: Key("expenseCategoryAmountField"),
              decoration: InputDecoration(labelText: "Enter Expense amount"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class MonthlyReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Monthly Report")),
    );
  }
}
