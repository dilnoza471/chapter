import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book_details_page.dart';
import '../models/book_model.dart';
import '../widgets/book_widget.dart';

class CatalogPage extends StatefulWidget {
  final String userRole;
  final VoidCallback onLogout;

  const CatalogPage({
    super.key,
    required this.userRole,
    required this.onLogout,
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  List<BookModel> books = [];
  List<BookModel> filteredBooks = [];
  bool isLoading = true;
  String? errorMessage;
  final baseUrl = "https://chapter-djfj.onrender.com";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBooks();
    _searchController.addListener(_filterBooks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBooks() {
    final query = _searchController.text.toLowerCase().trim();
    
    setState(() {
      if (query.isEmpty) {
        filteredBooks = books;
      } else {
        filteredBooks = books.where((book) {
          final titleMatch = book.title.toLowerCase().contains(query);
          final authorMatch = book.author.toLowerCase().contains(query);
          final categoryMatch = book.category.toLowerCase().contains(query);
          return titleMatch || authorMatch || categoryMatch;
        }).toList();
      }
    });
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
          filteredBooks = books;
          isLoading = false;
        });
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

  void _clearSearch() {
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            backgroundColor: const Color(0xFF1E88E5),
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: widget.onLogout,
                  tooltip: 'Logout (${widget.userRole})',
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Library Catalog',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 0.5,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: _buildSearchBar(),
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                ),
              ),
            )
          else if (errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Color(0xFFE53935),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (filteredBooks.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _searchController.text.isNotEmpty
                          ? Icons.search_off
                          : Icons.library_books_outlined,
                      color: const Color(0xFF90A4AE),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _searchController.text.isNotEmpty
                          ? 'No books match your search.'
                          : 'No books found.',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF90A4AE),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _clearSearch,
                        child: const Text('Clear Search'),
                      ),
                    ],
                  ],
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
                  return BookWidget(
                    book: filteredBooks[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailsPage(
                            book: filteredBooks[index],
                          ),
                        ),
                      );
                    },
                  );
                }, childCount: filteredBooks.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E88E5).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE3F2FD), width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search_rounded, color: Color(0xFF1E88E5), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Search books, authors, categories...',
                hintStyle: TextStyle(color: Color(0xFF90A4AE), fontSize: 15),
              ),
              style: const TextStyle(color: Color(0xFF263238), fontSize: 15),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Color(0xFF90A4AE)),
              onPressed: _clearSearch,
              tooltip: 'Clear',
            ),
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF1E88E5)),
              onPressed: fetchBooks,
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
    );
  }
}