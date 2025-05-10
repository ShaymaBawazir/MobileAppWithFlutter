import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:provider/provider.dart';
import 'package:movies/providers/favorites_provider.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFavorite = favoriteProvider.isFavorite(movie);

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => favoriteProvider.toggleFavorite(movie),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'poster-${movie.id}',
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.poster_path}',
                  height: 300,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
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
                  },  ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Release Date: ${movie.release_date}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),
            const Text(
              'Overview:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              movie.overview,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}