import 'package:flutter/material.dart';
import 'package:finance_mobile/models/expenseCategory.dart';

import 'newCategoryScreen.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen();

  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Future<List<ExpenseCategory>> _categories;

  @override
  void initState() {
    updateCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                for (var category in snapshot.data) _categoryTile(category)
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: Key("categoryFloatingButton"),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewCategoryScreen(callback: updateCategories);
          }));
        },
      ),
    );
  }

  Widget _categoryTile(ExpenseCategory category) {
    return ListTile(
      title: Text(category.name),
    );
  }

  void updateCategories() {
    setState(() {
      this._categories = ExpenseCategory.list();
    });
  }
}
