import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:movies/models/movie.dart';

class DatabaseService {
  static const _dbName = 'moviesDb.db';
  static const _dbVersion = 1;
  static const _tableName = 'favorites';

  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final Dbpath = await getDatabasesPath();
    final path = join(Dbpath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "$_tableName" (
        "id" INTEGER PRIMARY KEY,
        "title" TEXT NOT NULL,
        "release_date" TEXT,
        "poster_path" TEXT,
        "overview" TEXT
      )
    ''');
  }

  Future<int> insertMovie(Movie movie) async {
    final db = await instance.database;
    return await db.insert(_tableName, movie.toMap());
  }

  Future<int> deleteMovie(int id) async {
    final db = await instance.database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Movie>> getFavorites() async {
    final db = await instance.database;
    final maps = await db.query(_tableName);
    return List.generate(maps.length, (i) => Movie.fromMap(maps[i]));
  }
}