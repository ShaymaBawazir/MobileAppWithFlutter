import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/movie.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _db;

  DBHelper._init();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB('movies.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        releaseDate TEXT
      )''');
  }

  Future<void> addFavorite(Movie m) async {
    final database = await db;
    await database.insert('favorites', m.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(int id) async {
    final database = await db;
    await database.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Movie>> getFavorites() async {
    final database = await db;
    final maps = await database.query('favorites');
    return maps.map((m) => Movie(
      id: m['id'] as int,
      title: m['title'] as String,
      overview: m['overview'] as String,
      posterPath: m['posterPath'] as String,
      releaseDate: m['releaseDate'] as String,
    )).toList();
  }
}
