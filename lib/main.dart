import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'expense.dart';

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  final List<Expense> expenses = [
    Expense(DateTime(2021, 05, 19), "Groceries", 300),
    Expense(DateTime(2021, 05, 18), "Taxi", 500),
    Expense(DateTime(2021, 05, 17), "Drinks", 600)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[300],
      ),
      home: HomeWidget(expenses: expenses),
    );
  }
}

class HomeWidget extends StatefulWidget {
  List<Expense> expenses;

  HomeWidget({this.expenses});

  @override
  State<StatefulWidget> createState() => HomeWidgetState(expenses: expenses);
}

class HomeWidgetState extends State<HomeWidget> {
  List<Expense> expenses;

  updatePage() {
    setState(() {});
  }

  HomeWidgetState({@required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [for (var expense in expenses) _expenseTile(expense)],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewExpenseScreen(expenses, updatePage);
          }));
        },
      ),
    );
  }

  Widget _expenseTile(Expense expense) {
    return ListTile(
      leading: Text(expense.amountStr()),
      title: Text(expense.category),
      subtitle: Text(expense.dateStr()),
      trailing: Icon(Icons.more_vert),
    );
  }
}

class NewExpenseScreen extends StatefulWidget {
  List<Expense> expenses;

  Function callback;

  NewExpenseScreen(this.expenses, this.callback);

  @override
  State<StatefulWidget> createState() =>
      _NewExpenseScreenState(expenses, callback);
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  DateTime _date;
  final List<String> categories = ["Groceries", "Taxi", "Drinks"];
  String _selectedCategory;
  List<Expense> expenses;
  String _amount;
  Function callback;

  _NewExpenseScreenState(expenses, callback) {
    this.expenses = expenses;
    this._date = DateTime.now();
    this._selectedCategory = categories.first;
    this.callback = callback;
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
                expenses.add(expense);
                callback();
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
                onChanged: (String newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
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
