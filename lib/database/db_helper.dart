import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SigmlFile {
  final int? id;
  final String fileName;
  final String sigmlData;

  SigmlFile({this.id, required this.fileName, required this.sigmlData});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileName': fileName,
      'sigmlData': sigmlData,
    };
  }

  factory SigmlFile.fromMap(Map<String, dynamic> map) {
    return SigmlFile(
      id: map['id'],
      fileName: map['fileName'],
      sigmlData: map['sigmlData'],
    );
  }
}

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;
  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

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

  Future<void> insertSigmlFile(SigmlFile sigmlFile) async {
    final db = await database;
    await db.insert(
      'sigmlFiles',
      sigmlFile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBulkSigmlFiles(List<SigmlFile> files) async {
    final db = await database;
    for (var file in files) {
      await db.insert(
        'sigmlFiles',
        file.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<SigmlFile>> getSigmlFiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sigmlFiles');
    return List.generate(maps.length, (i) => SigmlFile.fromMap(maps[i]));
  }
  
  Future<SigmlFile?> getSigmlFileByWord(String word) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sigmlFiles',
      where: 'fileName = ?',
      whereArgs: [word],
    );
    if (maps.isNotEmpty) {
      return SigmlFile.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
