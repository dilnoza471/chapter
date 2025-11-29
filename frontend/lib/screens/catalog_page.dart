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
  bool isLoading = true;
  String? errorMessage;
  final baseUrl = "https://chapter-djfj.onrender.com";

  @override
  void initState() {
    super.initState();
    fetchBooks();
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
          else if (books.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.library_books_outlined,
                      color: Color(0xFF90A4AE),
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No books found.',
                      style: TextStyle(fontSize: 18, color: Color(0xFF90A4AE)),
                    ),
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
                    book: books[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailsPage(book: books[index]),
                        ),
                      );
                    },
                  );
                }, childCount: books.length),
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
          const Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: 'Search books, authors...',
                hintStyle: TextStyle(color: Color(0xFF90A4AE), fontSize: 15),
              ),
              style: TextStyle(color: Color(0xFF263238), fontSize: 15),
            ),
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
