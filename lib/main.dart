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
    Expense("17.06.2021", "Grociries", 300),
    Expense("18.06.2021", "Taxi", 500),
    Expense("19.06.2021", "Drinks", 600)
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
            return NewExpenseScreen(expenses);
          }));
        },
      ),
    );
  }

  Widget _expenseTile(Expense expense) {
    return ListTile(
      leading: Text("${expense.amount} R"),
      title: Text(expense.category),
      subtitle: Text(expense.date),
      trailing: Icon(Icons.more_vert),
    );
  }
}

class NewExpenseScreen extends StatefulWidget {
  List<Expense> expenses;

  NewExpenseScreen(this.expenses);

  @override
  State<StatefulWidget> createState() => _NewExpenseScreenState(expenses);
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  DateTime _date;
  final List<String> categories = ["Groceries", "Taxi", "Drinks"];
  String _selectedCategory;
  List<Expense> expenses;
  String _amount;

  _NewExpenseScreenState(expenses) {
    this.expenses = expenses;
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
              onPressed: () {
                Expense expense = Expense("${_date.toLocal()}".split(" ")[0],
                    _selectedCategory, double.parse(_amount));
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
