import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const _baseUrl = 'https://api.themoviedb.org/3';
  static const _apiKey = '<YOUR_API_KEY>';

  Future<List<Movie>> fetchPopular() async {
    final url = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List results = data['results'];
      return results.map((j) => Movie.fromJson(j)).toList();
    } else if (res.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Server Error: \${res.statusCode}');
    }
  }
}