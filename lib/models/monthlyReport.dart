import 'package:finance_mobile/models/dbprovider.dart';
import 'package:finance_mobile/models/expense.dart';
import 'package:finance_mobile/models/expenseCategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class MonthlyReport {
  DateTime _date;
  Map<ExpenseCategory, List<num>> _data;

  MonthlyReport(this._date) {
    List<ExpenseCategory> categories;
    List<Expense> expenses;
    ExpenseCategory.list().then((value) {
      categories = value;
    });
    Expense.list().then((value) => expenses = value);

    _data = {};
    for (var category in categories) {
      _data[category] = [0, 0, 0];
    }

    // Totals
    for (Expense expense in expenses) {
      if (expense.date.month == _date.month &&
          expense.date.year == _date.year) {
        _data[expense.category][0] += expense.amount;
        _data[expense.category][1] += expense.amount;
        _data[expense.category][2] += expense.amount;
      }
    }
    //Previous Month
    for (Expense expense in expenses) {
      if ((expense.date.month == _date.month - 1 &&
              expense.date.year == _date.year) ||
          (expense.date.month == 1 && expense.date.year == _date.year - 1)) {
        _data[expense.category][1] -= expense.amount;
      }
    }
    //Year average
    List<Expense> closed = [];
    Map<ExpenseCategory, Map<int, double>> monthlySums = {};
    for (ExpenseCategory category in categories) {
      monthlySums[category] = {
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
        6: 0,
        7: 0,
        8: 0,
        9: 0,
        10: 0,
        11: 0,
        12: 0
      };
    }
    for (int month = 12; month > 0; month--) {
      DateTime monthStart = DateTime(_date.year, _date.month - month);
      DateTime monthEnd = DateTime(_date.year, _date.month - month + 1, 0);
      for (Expense expense in expenses) {
        if (!closed.contains(expense)) {
          if (expense.date.isAfter(monthStart) &&
              expense.date.isBefore(monthEnd)) {
            monthlySums[expense.category][month] += expense.amount;
            closed.add(expense);
          }
        }
      }
    }
    for (ExpenseCategory category in monthlySums.keys) {
      double sum = 0;
      int zeroMonth = 0;
      for (int month in monthlySums[category].keys) {
        if (monthlySums[category][month] == 0) {
          zeroMonth++;
        }
        sum += monthlySums[category][month];
      }
      double average = sum / (12 - zeroMonth);
      _data[category][2] -= average;
    }
  }

  Map<ExpenseCategory, List<num>> get data => _data;

  DateTime get date => _date;

  static Future<MonthlyReport> get(DateTime date) async {
    Database db = await DBProvider.db.database;
    var reports = db.query("monthlyReports");
  }
}
