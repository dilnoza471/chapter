import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../models/book_model.dart';
import '../widgets/book_widget.dart';

class FavoritesScreen extends StatefulWidget {
  final FavoritesService favoritesService;
  final Future<BookModel> Function(String id) fetchBookById;
  final String? authToken;

  /// Provide a fetchBookById callback that returns a BookModel given its id.
  const FavoritesScreen({
    Key? key,
    required this.favoritesService,
    required this.fetchBookById,
    this.authToken,
  }) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favoriteIds = [];
  List<BookModel> _books = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _loading = true);
    final ids = await widget.favoritesService.getLocalFavorites();
    _favoriteIds = ids;
    // fetch details (in parallel)
    try {
      final futures = ids.map((id) => widget.fetchBookById(id)).toList();
      _books = await Future.wait(futures);
    } catch (e) {
      // If fetch fails for some items, ignore and keep what succeeded
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _onRemove(BookModel book) async {
    await widget.favoritesService.removeFavoriteLocal(book.id);
    if (widget.authToken != null) {
      widget.favoritesService.removeFavoriteRemote(book.id, widget.authToken!).catchError((_) {});
    }
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _books.isEmpty
              ? const Center(child: Text('No favorites yet'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Stack(
                      children: [
                        BookWidget(
                          book: book,
                          onTap: () {
                            // navigate to BookDetailsPage in your app, e.g.:
                            // Navigator.of(context).push(... pass book ...)
                          },
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: () => _onRemove(book),
                              tooltip: 'Remove from favorites',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
