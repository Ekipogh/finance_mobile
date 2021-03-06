import 'category.dart';

class Expense {
  DateTime date;
  Category category;
  double amount;

  Expense(this.date, this.category, this.amount);

  String dateStr() {
    return "${this.date.day}.${this.date.month}.${this.date.year}";
  }
  String amountStr(){
    return "${this.amount} R";
  }
}
