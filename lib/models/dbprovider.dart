import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  get database {
    if (_database != null) {
      return _database;
    }
    _database = initDB();
    return _database;
  }

  initDB() async {
    return openDatabase(join(await getDatabasesPath(), 'finance_database.db'),
        onCreate: (db, version) {
      return db
          .execute("CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT)");
    }, version: 1);
  }
}
