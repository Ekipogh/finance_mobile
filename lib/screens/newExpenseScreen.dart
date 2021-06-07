import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

import '../category.dart';
import '../expense.dart';

class NewExpenseScreen extends StatefulWidget {
  final Function callback;
  final List<Category> categories;

  NewExpenseScreen({this.callback, this.categories});

  @override
  State<StatefulWidget> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  DateTime _date;
  Category _selectedCategory;
  String _amount;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    this._date = DateTime.now();
    this._selectedCategory = widget.categories.first;
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
                  Expense expense =
                      Expense(_date, _selectedCategory, double.parse(_amount));
                  widget.callback(expense);
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
                  DropdownButtonFormField(
                    key: Key("expenseCategoryDropDown"),
                    value: _selectedCategory,
                    onChanged: (Category newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                    items: widget.categories
                        .map<DropdownMenuItem<Category>>((Category value) {
                      return DropdownMenuItem<Category>(
                          value: value, child: Text(value.toString()));
                    }).toList(),
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
