import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:provider/provider.dart';
import 'package:movies/providers/favorites_provider.dart';

import 'details_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favorites = favoriteProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final movie = favorites[index];

          return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child:ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading:SizedBox(width: 60,
               child:  ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network( 'https://image.tmdb.org/t/p/w92${movie.poster_path}',
                width: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                      width: 60, // نفس عرض الـ leading
                      height: 60, // تحديد ارتفاع ثابت
                      child:Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1),
                    ),
                  ),);
                },),
            ),),
            title: Text(movie.title,
              style:TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),   ),
            subtitle: Text('Release Date: ${movie.release_date}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
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
          )

          );
        },
      ),
      );
  }
}