import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  get database async {
    if (this._database != null) {
      return this._database;
    }
    this._database = await initDB();
    return this._database;
  }

  initDB() async {
    return openDatabase(join(await getDatabasesPath(), 'finance_database.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT)");
    }, version: 1);
  }
}
