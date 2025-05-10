import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String apiKey = '95ef27dd128c20f1166d825fbe35a173';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchPopularMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List movies = data['results'];
      return movies.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}
