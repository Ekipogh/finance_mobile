import 'package:finance_mobile/screens/importSceen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'expense.dart';
import 'category.dart';
import 'monthlyReport.dart';

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
              key: Key("StatisticsButton"),
              title: Text("Statistics"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return StatisticsScreen(
                      expenses: widget.expenses, categories: widget.categories);
                }));
              },
            ),
            ListTile(
              key: Key("ImportButton"),
              title: Text("Import"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ImportScreen();
                }));
              },
            ),
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
                  Category category = Category(_categoryName);
                  widget.callback(category);
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

class StatisticsScreen extends StatelessWidget {
  final List<Expense> expenses;
  final List<Category> categories;

  StatisticsScreen({this.expenses, this.categories});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.assessment),
                  text: "Graphs",
                ),
                Tab(
                  icon: Icon(Icons.today),
                  text: "Monthly report",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Text("Graphs"),
              ),
              MonthlyReportScreen(expenses: expenses, categories: categories),
            ],
          ),
        ));
  }
}

class MonthlyReportScreen extends StatefulWidget {
  final List<Expense> expenses;
  final List<Category> categories;

  MonthlyReportScreen({this.expenses, this.categories});

  @override
  State<StatefulWidget> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen>
    with AutomaticKeepAliveClientMixin<MonthlyReportScreen> {
  DateTime _date;
  String _formattedDate;
  MonthlyReport _currentReport;
  List<MonthlyReport> reports;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _date = DateTime.now();
    reports = [];
    setFormattedDate();
    super.initState();
  }

  void setFormattedDate() {
    DateFormat formatter = DateFormat('MMMM yyyy');
    _formattedDate = formatter.format(_date);
  }

  void setCurrentReport() {
    for (MonthlyReport report in reports) {
      if (report.date.month == _date.month && report.date.year == _date.year) {
        _currentReport = report;
        return;
      }
    }
    _currentReport = null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _date = DateTime(_date.year, _date.month - 1);
                    setFormattedDate();
                    setCurrentReport();
                  });
                },
                icon: Icon(Icons.arrow_left)),
            SizedBox(
                width: 160,
                child: TextButton(
                    onPressed: () {}, child: Text("$_formattedDate"))),
            IconButton(
                onPressed: () {
                  setState(() {
                    _date = DateTime(_date.year, _date.month + 1);
                    setFormattedDate();
                    setCurrentReport();
                  });
                },
                icon: Icon(Icons.arrow_right)),
          ],
        ),
        if (_currentReport == null)
          Center(
            child: ElevatedButton(
              child: Text("Create the report"),
              onPressed: () async {
                DateTime nowDate = DateTime.now();
                bool answer = true;
                bool isDateAfter = _date.isAfter(nowDate) ||
                    (_date.month == nowDate.month &&
                        _date.year == nowDate.year);
                if (isDateAfter) {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Are you sure"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text("Selected month is now or in the future."),
                                Text("Are you sure you want to proceed?"),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  answer = false;
                                },
                                child: Text("Cancel")),
                          ],
                        );
                      });
                }
                setState(() {
                  if (answer) {
                    MonthlyReport report = MonthlyReport(
                        _date, widget.expenses, widget.categories);
                    reports.add(report);
                    setCurrentReport();
                    setFormattedDate();
                  }
                });
              },
            ),
          )
        else
          MonthlyReportDetailsScreen(report: _currentReport)
      ],
    );
  }
}

class MonthlyReportDetailsScreen extends StatelessWidget {
  final MonthlyReport report;

  MonthlyReportDetailsScreen({this.report});

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Previous Month",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Year round monthly average",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),
        for (var entry in report.data.entries)
          TableRow(children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entry.key.name),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entry.value[0].toString()),
              ),
            ),
            TableCell(
              child: Container(
                color: (entry.value[1] > 0)
                    ? Colors.deepOrangeAccent
                    : Colors.lightGreen,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    entry.value[1].toString(),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                color: (entry.value[2] > 0)
                    ? Colors.deepOrangeAccent
                    : Colors.lightGreen,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    entry.value[2].toString(),
                  ),
                ),
              ),
            )
          ])
      ],
    );
  }
}
