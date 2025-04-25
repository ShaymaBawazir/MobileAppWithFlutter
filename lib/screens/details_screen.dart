import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/favorites_provider.dart';

class DetailsScreen extends StatelessWidget {
  final Movie movie;
  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoritesProvider>(context);
    final isFav = favProv.isFavorite(movie.id);

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://image.tmdb.org/t/p/w500\${movie.posterPath}'),
            const SizedBox(height: 16),
            Text('Release: \${movie.releaseDate}'),
            const SizedBox(height: 16),
            Text(movie.overview),
            const Spacer(),
            ElevatedButton(
              onPressed: () => isFav ? favProv.remove(movie.id) : favProv.add(movie),
              child: Text(isFav ? 'Remove from Favorites' : 'Add to Favorites'),
            ),
          ],
        ),
      ),
    );
  }
}