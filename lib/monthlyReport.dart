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
  }

  Map<Category, List<num>> get data => _data;

  DateTime get date => _date;
}
