import 'package:flutter/material.dart';
import '../services/favorites_service.dart';

class FavoriteHeartIcon extends StatefulWidget {
  final String bookIsbn;
  final bool initialIsFavorited;
  final VoidCallback? onFavoriteChanged;

  const FavoriteHeartIcon({
    super.key,
    required this.bookIsbn,
    this.initialIsFavorited = false,
    this.onFavoriteChanged,
  });

  @override
  State<FavoriteHeartIcon> createState() => _FavoriteHeartIconState();
}

class _FavoriteHeartIconState extends State<FavoriteHeartIcon> {
  late bool isFavorited;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.initialIsFavorited;
  }

  Future<void> _toggleFavorite() async {
  setState(() => isLoading = true);

  try {
    final favoritesService = FavoritesService();

    if (isFavorited) {
      await favoritesService.removeFavorite(widget.bookIsbn);
    } else {
      await favoritesService.addFavorite(widget.bookIsbn);
    }

    setState(() => isFavorited = !isFavorited);
    widget.onFavoriteChanged?.call();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFavorited ? 'Added to favorites' : 'Removed from favorites'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      // Handle duplicate error gracefully
      final errorMsg = e.toString();
      if (errorMsg.contains('duplicate key')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Already in favorites')),
        );
        setState(() => isFavorited = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  } finally {
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited ? Colors.red : Colors.grey,
            size: 24,
          ),
          onPressed: isLoading ? null : _toggleFavorite,
        ),
      ),
    );
  }
}