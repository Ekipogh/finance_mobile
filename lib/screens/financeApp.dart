import 'package:finance_mobile/models/expense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finance_mobile/models/expenseCategory.dart';

import 'homeWidget.dart';

class FinanceApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[300],
      ),
      home: HomeWidget(),
    );
  }
}
