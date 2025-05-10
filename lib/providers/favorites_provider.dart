import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
//import 'package:movies/services/database_service.dart';

import '../db/database_service.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Movie> _favorites = [];
  final DatabaseService _db = DatabaseService.instance;

  List<Movie> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites.clear();
    _favorites.addAll(await _db.getFavorites());
    notifyListeners();
  }

  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie)) {
      await _db.deleteMovie(movie.id);
      _favorites.removeWhere((m) => m.id == movie.id);
    } else {
      await _db.insertMovie(movie);
      _favorites.add(movie);
    }
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favorites.any((m) => m.id == movie.id);
  }
}