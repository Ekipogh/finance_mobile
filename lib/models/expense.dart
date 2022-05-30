import 'package:finance_mobile/models/dbprovider.dart';
import 'package:finance_mobile/models/expenseCategory.dart';

class Expense {
  int id;
  DateTime date;
  ExpenseCategory category;
  double amount;

  Expense({this.id, this.date, this.category, this.amount});

  String dateStr() {
    return "${this.date.day}.${this.date.month}.${this.date.year}";
  }

  String amountStr() {
    return "${this.amount} R";
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "date": date.millisecondsSinceEpoch,
        "categoryId": category.id,
        "amount": amount,
      };

  static Future<Expense> fromMap(Map<String, dynamic> map) async {
    return Expense(
        id: map["id"],
        category: await ExpenseCategory.get(map["categoryId"]),
        amount: map["amount"],
        date: DateTime.fromMillisecondsSinceEpoch(map["date"]));
  }

  save() async {
    final db = await DBProvider.db.database;
    await db.insert("expenses", this.toMap());
    return this;
  }

  static Future<List<Expense>> list() async {
    final db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    List<Expense> list = [];
    for (var map in maps) {
      Expense expense = await Expense.fromMap(map);
      list.add(expense);
    }
    return list;
  }
}
