import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../db/db_helper.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Movie> favs = [];

  Future<void> loadFavorites() async {
    favs = await DBHelper.instance.getFavorites();
    notifyListeners();
  }

  Future<void> add(Movie m) async {
    await DBHelper.instance.addFavorite(m);
    await loadFavorites();
  }

  Future<void> remove(int id) async {
    await DBHelper.instance.removeFavorite(id);
    await loadFavorites();
  }

  bool isFavorite(int id) => favs.any((m) => m.id == id);
}