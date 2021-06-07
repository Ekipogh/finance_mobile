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

  save() async {
    final db = await DBProvider.db.database;
    await db.insert("categories", this.toMap());
    return this;
  }

  static get(int id) async {
    final db = await DBProvider.db.database;
    return await db.query("categories", where: "id = ?", whereArgs: [id]);
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
