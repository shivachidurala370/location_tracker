import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/location_model.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('location_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tracking_sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_time TEXT,
        end_time TEXT,
        total_points INTEGER DEFAULT 0
      )
      ''');

    await db.execute('''
      CREATE TABLE locations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER,
        latitude REAL,
        longitude REAL,
        timestamp TEXT,
        accuracy REAL,
        FOREIGN KEY(session_id)
        REFERENCES tracking_sessions(id)
      )
      ''');
  }

  Future<int> insertLocation(LocationModel location) async {
    final db = await instance.database;
    final id = await db.insert('locations', location.toMap());

    print("LOCATION SAVED ID: $id");

    return id;
  }

  Future<List<LocationModel>> fetchAllLocations() async {
    final db = await instance.database;
    final orderBy = 'timestamp DESC';
    final result = await db.query('locations', orderBy: orderBy);

    return result.map((json) => LocationModel.fromMap(json)).toList();
  }

  Future<int> createSession() async {
    final db = await database;

    return db.insert('tracking_sessions', {
      'start_time': DateTime.now().toIso8601String(),
      'total_points': 0,
    });
  }

  Future<void> finishSession(int id) async {
    final db = await database;

    await db.update(
      'tracking_sessions',
      {'end_time': DateTime.now().toIso8601String()},
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
