import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (this._database != null) {
      return this._database;
    }
    this._database = await initDB();
    return this._database;
  }

  initDB() async {
    return openDatabase(join(await getDatabasesPath(), 'finance_database.db'),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE categories(id INTEGER, name TEXT, PRIMARY KEY(id))");
      await db.execute(
          "CREATE TABLE expenses(id INTEGER, date INTEGER, categoryId INTEGER, amount DOUBLE, PRIMARY KEY(id), FOREIGN KEY(categoryId) REFERENCES categories(id))");
    }, version: 1);
  }
}
