import 'package:finance_mobile/models/dbprovider.dart';

class ExpenseCategory {
  int id;
  String name;

  ExpenseCategory({this.id, this.name});

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };

  static ExpenseCategory fromMap(Map<String, dynamic> map) {
    return ExpenseCategory(id: map["id"], name: map["name"]);
  }

  Future<ExpenseCategory> save() async {
    final db = await DBProvider.db.database;
    await db.insert("categories", this.toMap());
    return this;
  }

  static Future<ExpenseCategory> get(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("categories", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? ExpenseCategory.fromMap(res.first) : null;
  }

  static Future<List<ExpenseCategory>> list() async {
    final db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(
        maps.length,
        (index) => ExpenseCategory(
              id: maps[index]["id"],
              name: maps[index]["name"],
            ));
  }
}
