import 'package:flutter/material.dart';

import '../category.dart';
import 'newCategoryScreen.dart';

class CategoryScreen extends StatefulWidget {
  final List<Category> categories;

  CategoryScreen({this.categories});

  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (var category in widget.categories) _categoryTile(category)
        ],
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

  Widget _categoryTile(Category category) {
    return ListTile(
      title: Text(category.name),
    );
  }

  void updateCategories(Category category) {
    setState(() {
      widget.categories.add(category);
    });
  }
}