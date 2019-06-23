import 'package:elliot/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

// Make this a singleton class.
  DatabaseManager._privateConstructor();
  static final instance = DatabaseManager._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE tasks (
                id INTEGER PRIMARY KEY,
                tag TEXT,
                title TEXT NOT NULL,
                description TEXT NOT NULL,
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Task task) async {
    Database db = await database;
    int id = await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Task>> queryTask(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(
      'tasks',
    );
    if (maps.length > 0) {
      return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
    }
    return null;
  }
}
