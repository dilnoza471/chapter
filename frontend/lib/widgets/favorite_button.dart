import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/favorites_service.dart';

/// FavoriteButton expects a BookModel (your BookWidget requires book).
/// It toggles local favorite state and attempts a remote sync if authToken is provided.
class FavoriteButton extends StatefulWidget {
  final BookModel book;
  final FavoritesService favoritesService;
  final String? authToken; // optional for remote sync

  const FavoriteButton({
    Key? key,
    required this.book,
    required this.favoritesService,
    this.authToken,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFav = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final val = await widget.favoritesService.isFavorite(widget.book.id);
    setState(() {
      _isFav = val;
      _loading = false;
    });
  }

  Future<void> _toggle() async {
    setState(() => _loading = true);
    try {
      if (_isFav) {
        await widget.favoritesService.removeFavoriteLocal(widget.book.id);
        if (widget.authToken != null) {
          // attempt remote removal but don't block UI on failure
          widget.favoritesService.removeFavoriteRemote(widget.book.id, widget.authToken!).catchError((_) {});
        }
      } else {
        await widget.favoritesService.addFavoriteLocal(widget.book.id);
        if (widget.authToken != null) {
          widget.favoritesService.addFavoriteRemote(widget.book.id, widget.authToken!).catchError((_) {});
        }
      }
      setState(() => _isFav = !_isFav);
    } catch (e) {
      // user-visible error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not update favorite')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 22,
      icon: _loading
          ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(_isFav ? Icons.star : Icons.star_border),
      onPressed: _loading ? null : _toggle,
      tooltip: _isFav ? 'Remove from favorites' : 'Add to favorites',
    );
  }
}
