import 'package:elliot/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDatabase {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "HistoryDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;
  static final _tableName = 'history';

// Make this a singleton class.
  HistoryDatabase._privateConstructor();
  static final instance = HistoryDatabase._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    return await db.execute('''
               CREATE TABLE history(
                id STRING PRIMARY KEY,
                tagTitle TEXT,
                tagColor INT,
                title TEXT NOT NULL,
                description TEXT NOT NULL,
                details TEXT NOT NULL,
                progress INT NOT NULL,
                deadline INT,
                dateCreated INT NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<List<Task>> getTasks() async {
    Database db = await database;
    List<Map> maps = await db.query(
      _tableName,
    );
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<int> insert(Task task) async {
    Database db = await database;
    int id = await db.insert(
      _tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(task.toMap());
    return id;
  }

  Future<void> update(Task task) async {
    Database db = await database;
    await db.update(_tableName, task.toMap(),
        where: "id = ?", whereArgs: [task.id]);
    print(task.toMap());
  }

  Future<void> delete(String id) async {
    Database db = await database;
    await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    Database db = await database;
    await db.delete(_tableName);
  }

  Future<List<Task>> queryTask(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(
      _tableName,
    );
    if (maps.length > 0) {
      return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
    }
    return null;
  }
}
