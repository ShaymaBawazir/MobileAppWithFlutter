import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: favProv.favs.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : ListView.builder(
        itemCount: favProv.favs.length,
        itemBuilder: (_, i) {
          final m = favProv.favs[i];
          return ListTile(
            leading: Image.network('https://image.tmdb.org/t/p/w92\${m.posterPath}'),
            title: Text(m.title),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsScreen(movie: m))),
          );
        },
      ),
    );
  }
}
