import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'sigml_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  // Access the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sigml_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sigmlFiles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fileName TEXT,
            sigmlData TEXT
          )
        ''');
      },
    );
  }

  // Insert a SiGML file into the database
  Future<void> insertSigmlFile(SigmlFile sigmlFile) async {
    final db = await database;
    await db.insert(
      'sigmlFiles',
      sigmlFile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all SiGML files from the database
  Future<List<SigmlFile>> getSigmlFiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sigmlFiles');

    return List.generate(maps.length, (i) {
      return SigmlFile.fromMap(maps[i]);
    });
  }

  // Delete a SiGML file by id
  Future<void> deleteSigmlFile(int id) async {
    final db = await database;
    await db.delete(
      'sigmlFiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
