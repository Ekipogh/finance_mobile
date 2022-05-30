import 'package:date_field/date_field.dart';
import 'package:finance_mobile/models/expense.dart';
import 'package:finance_mobile/models/expenseCategory.dart';
import 'package:flutter/material.dart';

class NewExpenseScreen extends StatefulWidget {
  final Function callback;

  NewExpenseScreen({this.callback});

  @override
  State<StatefulWidget> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  DateTime _date;
  ExpenseCategory _selectedCategory;
  String _amount;
  Future<List<ExpenseCategory>> categories;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    this._date = DateTime.now();
    categories = ExpenseCategory.list();
    categories.then((value) {
      this._selectedCategory = value.first;
    });
    super.initState();
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
                if (_formKey.currentState.validate()) {
                  Expense expense = Expense(
                      date: _date,
                      category: _selectedCategory,
                      amount: double.parse(_amount));
                  expense.save();
                  widget.callback();
                  Navigator.of(context).pop();
                }
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DateTimeFormField(
                    initialValue: _date,
                    onDateSelected: (value) {
                      setState(() {
                        _date = value;
                      });
                    },
                    mode: DateTimeFieldPickerMode.date,
                  ),
                  FutureBuilder(
                    key: Key("expenseCategoryFutureBuilder"),
                    future: categories,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DropdownButtonFormField(
                          key: Key("expenseCategoryDropDown"),
                          value: _selectedCategory,
                          onChanged: (ExpenseCategory newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          },
                          items: snapshot.data
                              .map<DropdownMenuItem<ExpenseCategory>>(
                                  (ExpenseCategory value) {
                            return DropdownMenuItem<ExpenseCategory>(
                                value: value, child: Text(value.toString()));
                          }).toList(),
                        );
                      }
                      return Text("Please create some categories");
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (num.tryParse(value) == null) {
                        return "Please enter a number";
                      }
                      return null;
                    },
                    key: Key("expenseAmountField"),
                    decoration:
                        InputDecoration(labelText: "Enter Expense amount"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _amount = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
