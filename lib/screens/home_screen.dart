import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/api_service.dart';
import 'package:movies/screens/favorites_screen.dart';
import 'package:provider/provider.dart';
import 'package:movies/screens/details_screen.dart';
import '../providers/favorites_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();

    _moviesFuture = ApiService().fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoriteScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Please Check The Internet Connection'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found.'));
          } else {
            final movies = snapshot.data!;
            return Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    final favorite = favoriteProvider.isFavorite(movie);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: SizedBox(
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w92${movie.poster_path}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ?? 1),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        title: Text(
                          movie.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          'Release Date: ${movie.release_date}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            favorite ? Icons.favorite : Icons.favorite_border,
                            color: favorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            favoriteProvider.toggleFavorite(movie);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(movie: movie),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}