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
  List<Category> categories;
  List<Expense> expenses;

  _FinanceAppState() {
    categories = [
      Category("Groceries"),
      Category("Taxi"),
      Category("Drinks"),
    ];
    expenses = [
      Expense(DateTime(2021, 05, 19), categories[0], 300),
      Expense(DateTime(2021, 05, 18), categories[1], 500),
      Expense(DateTime(2021, 05, 17), categories[2], 600)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[300],
      ),
      home: HomeWidget(
          expenses: expenses, categories: categories, callback: updateExpenses),
    );
  }

  updateExpenses(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }
}

class HomeWidget extends StatefulWidget {
  final List<Expense> expenses;
  final List<Category> categories;
  final Function callback;

  HomeWidget({this.expenses, this.callback, this.categories});

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
                  return CategoryScreen(
                    categories: widget.categories,
                  );
                }));
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

class CategoryScreen extends StatefulWidget {
  final List<Category> categories;

  CategoryScreen({this.categories});

  @override
  State<StatefulWidget> createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
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

class NewCategoryScreen extends StatefulWidget {
  final Function callback;

  NewCategoryScreen({this.callback});

  @override
  State<StatefulWidget> createState() => NewCategoryScreenState();
}

class NewCategoryScreenState extends State<NewCategoryScreen> {
  String _categoryName;

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
                Category category = Category(_categoryName);
                widget.callback(category);
                Navigator.of(context).pop();
              },
              child: Text("Save"))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              key: Key("newCategoryNameField"),
              decoration: InputDecoration(labelText: "Enter new category name"),
              onChanged: (value) {
                _categoryName = value;
              },
            )
          ],
        ),
      ),
    );
  }
}

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
                items: widget.categories
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
