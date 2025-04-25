import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import 'details_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MovieProvider>(context, listen: false).loadPopular();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies'), actions: [
        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())), icon: const Icon(Icons.favorite)),
      ]),
      body: provider.popular.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: provider.popular.length,
        itemBuilder: (_, i) {
          final m = provider.popular[i];
          return ListTile(
            leading: Image.network('https://image.tmdb.org/t/p/w92\${m.posterPath}'),
            title: Text(m.title),
            subtitle: Text(m.releaseDate),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsScreen(movie: m))),
          );
        },
      ),
    );
  }
}