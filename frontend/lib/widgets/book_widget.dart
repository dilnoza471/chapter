import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookWidget extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onTap;

  const BookWidget({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover takes most of the available height - FIXED: Removed Center wrapper
            Expanded(
              flex: 6,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      book.coverImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE3F2FD),
                        child: const Icon(
                          Icons.book,
                          size: 64,
                          color: Color(0xFF1E88E5),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getAvailabilityColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          book.availabilityStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info takes the rest
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF546E7A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvailabilityColor() {
    if (book.availableCopies == 0) return const Color(0xFFE53935);
    if (book.availableCopies <= 2) return const Color(0xFFFB8C00);
    return const Color(0xFF43A047);
  }
}
