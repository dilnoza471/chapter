import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../widgets/favorite_heart_icon.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  late Future<List<dynamic>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoritesFuture = _favoritesService.getUserFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() => _loadFavorites()),
        child: FutureBuilder<List<dynamic>>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final favorites = snapshot.data ?? [];

            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                final book = favorite['books'];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: book['coverImageUrl'] != null
                        ? Image.network(
                            book['coverImageUrl'],
                            width: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                color: Colors.grey[300],
                                child: const Icon(Icons.book),
                              );
                            },
                          )
                        : Container(
                            width: 50,
                            color: Colors.grey[300],
                            child: const Icon(Icons.book),
                          ),
                    title: Text(book['title'] ?? 'Unknown Title'),
                    subtitle: Text(book['author'] ?? 'Unknown Author'),
                    trailing: SizedBox(
                    width: 48,
                    height: 48,
                    child: FavoriteHeartIcon(
                      bookIsbn: favorite['book_isbn'],
                      initialIsFavorited: true,
                      onFavoriteChanged: () {
                        setState(() => _loadFavorites());
                      },
                    ),
                  ),
                    onTap: () {
                      // Navigate to book details
                      // Navigator.push(context, MaterialPageRoute(
                      //   builder: (_) => BookDetailsPage(book: book),
                      // ));
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}