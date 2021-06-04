import 'package:finance_mobile/expense.dart';
import 'package:finance_mobile/category.dart';

class MonthlyReport {
  DateTime _date;
  Map<Category, List<num>> _data;

  MonthlyReport(this._date, List<Expense> expenses, List<Category> categories) {
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
    Map<Category, Map<int, double>> monthlySums = {};
    for (Category category in categories) {
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
    for (Category category in monthlySums.keys) {
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

  Map<Category, List<num>> get data => _data;

  DateTime get date => _date;
}
