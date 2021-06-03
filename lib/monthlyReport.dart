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
    Map<Category, Map<int, double>> monthly_sums = {};
    for (Category category in categories) {
      monthly_sums[category] = {
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
      DateTime month_start = DateTime(_date.year, _date.month - month);
      DateTime month_end = DateTime(_date.year, _date.month - month + 1, 0);
      for (Expense expense in expenses) {
        if (!closed.contains(expense)) {
          if (expense.date.isAfter(month_start) &&
              expense.date.isBefore(month_end)) {
            monthly_sums[expense.category][month] += expense.amount;
            closed.add(expense);
          }
        }
      }
    }
    for (Category category in monthly_sums.keys) {
      double sum = 0;
      int zero_month = 0;
      for (int month in monthly_sums[category].keys) {
        if (monthly_sums[category][month] == 0) {
          zero_month++;
        }
        sum += monthly_sums[category][month];
      }
      double average = sum / (12 - zero_month);
      _data[category][2] -= average;
    }
  }

  Map<Category, List<num>> get data => _data;

  DateTime get date => _date;
}
