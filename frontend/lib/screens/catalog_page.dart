import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book_details_page.dart';
import '../models/book_model.dart';
import '../widgets/book_widget.dart';
import '../theme/app_colors.dart';

class CatalogPage extends StatefulWidget {
  final String userRole;
  final VoidCallback onLogout;
  final void Function(String isbn)? onRequestBorrow;

  const CatalogPage({
    super.key,
    required this.userRole,
    required this.onLogout,
    this.onRequestBorrow,
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
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppColors.primary,
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryForeground.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.logout, color: AppColors.primaryForeground),
                  onPressed: widget.onLogout,
                  tooltip: 'Logout (${widget.userRole})',
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Library Catalog',
                style: TextStyle(
                  color: AppColors.primaryForeground,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 0.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(color: AppColors.primary),
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
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            )
          else if (errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.destructive,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.destructive,
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
                      color: AppColors.muted,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _searchController.text.isNotEmpty
                          ? 'No books match your search.'
                          : 'No books found.',
                      style: TextStyle(fontSize: 18, color: AppColors.muted),
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
                      () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailsPage(
                              book: filteredBooks[index],
                              userRole: widget.userRole,
                            ),
                          ),
                        );

                        // If BookDetailsPage signalled we should open the Borrow tab,
                        // propagate the ISBN to the app via the callback.
                        if (result is Map &&
                            result['action'] == 'openBorrow' &&
                            result['isbn'] != null) {
                          widget.onRequestBorrow?.call(
                            result['isbn'] as String,
                          );
                        }
                      }();
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
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search_rounded, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration.collapsed(
                hintText: 'Search books, authors, categories...',
                hintStyle: TextStyle(color: AppColors.muted, fontSize: 15),
              ),
              style: TextStyle(color: AppColors.foreground, fontSize: 15),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: AppColors.muted),
              onPressed: _clearSearch,
              tooltip: 'Clear',
            ),
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.refresh, color: AppColors.primary),
              onPressed: fetchBooks,
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
    );
  }
}
