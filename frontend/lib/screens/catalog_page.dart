import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'book_details_page.dart';
import '../models/book_model.dart';
import '../widgets/book_widget.dart';

class CatalogPage extends StatefulWidget {
  // NEW: Add userRole and onLogout as required parameters
  final String userRole;
  final VoidCallback onLogout;
  
  const CatalogPage({super.key, required this.userRole, required this.onLogout});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage>
    with SingleTickerProviderStateMixin {
  List<BookModel> books = [];
  bool isLoading = true;
  String? errorMessage;
  // IMPORTANT: Use 10.0.2.2 for Android emulator to reach localhost
  final baseUrl = "http://127.0.0.1:5001"; 
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    fetchBooks();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchBooks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/books'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          books = data.map((json) => BookModel.fromJson(json)).toList();
          isLoading = false;
        });
        _animationController.forward();
      } else {
        setState(() {
          errorMessage = 'Failed to load books (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading books: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the currently applied Theme from the BuildContext
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            backgroundColor: theme.primaryColor,
            actions: [
              // NEW: Logout Button
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: widget.onLogout,
                tooltip: 'Logout (${widget.userRole})',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              title: Text(
                'Library Catalog',
                style: TextStyle(
                  // Adjust color for visibility against primaryColor
                  color: isDark ? Colors.white : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: _buildSearchBar(theme),
            ),
          ),

          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ),
            )
          else if (books.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No books found.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width >= 800
                      ? 200 
                      : 160, 
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3 / 5.4, 
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return FadeTransition(
                    opacity: _animationController.drive(
                      CurveTween(
                        curve: Interval((index * 0.1).clamp(0.0, 1.0), 1.0),
                      ),
                    ),
                    child: BookWidget(
                      book: books[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailsPage(book: books[index]),
                          ),
                        );
                      },
                    ),
                  );
                }, childCount: books.length),
              ),
            ),
        ],
      ),
    );
  }

  //implement the searchbar here
  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search_rounded, color: Colors.grey),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField( // Changed from Text to TextField for search
              decoration: InputDecoration.collapsed(
                hintText: 'Search books, authors...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.grey),
            onPressed: fetchBooks,
          ),
        ],
      ),
    );
  }
}