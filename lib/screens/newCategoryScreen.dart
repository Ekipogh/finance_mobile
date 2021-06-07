import 'package:finance_mobile/models/expenseCategory.dart';
import 'package:flutter/material.dart';

class NewCategoryScreen extends StatefulWidget {
  final Function callback;

  NewCategoryScreen({this.callback});

  @override
  State<StatefulWidget> createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  String _categoryName;
  final _formKey = GlobalKey<FormState>();

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
              key: Key("saveCategoryButton"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  ExpenseCategory category =
                      ExpenseCategory(name: _categoryName);
                  category.save();
                  widget.callback();
                  Navigator.of(context).pop();
                }
              },
              child: Text("Save"))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == "" && value.isEmpty) {
                    return "Please enter category name";
                  }
                  return null;
                },
                key: Key("newCategoryNameField"),
                decoration:
                    InputDecoration(labelText: "Enter new category name"),
                onChanged: (value) {
                  _categoryName = value;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
