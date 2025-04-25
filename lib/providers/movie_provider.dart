import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Movie> popular = [];

  Future<void> loadPopular() async {
    popular = await _api.fetchPopular();
    notifyListeners();
  }
}