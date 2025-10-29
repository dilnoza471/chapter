class BookModel {
  final String id;
  final String isbn;
  final String title;
  final String author;
  final String description;
  final DateTime publicationDate;
  final String language;
  final String category;
  final String coverImageUrl;
  int totalCopies;
  int availableCopies;

  BookModel({
    required this.id,
    required this.isbn,
    required this.title,
    required this.author,
    required this.description,
    required this.publicationDate,
    required this.language,
    required this.category,
    required this.coverImageUrl,
    required this.totalCopies,
    required this.availableCopies,
  });

  // Check if book is available
  bool get isAvailable => availableCopies > 0;

  // Get availability status
  String get availabilityStatus {
    if (availableCopies == 0) return 'Out of Stock';
    if (availableCopies <= 2) return 'Limited';
    return 'Available';
  }

  // Create from JSON
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      isbn: json['isbn'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      publicationDate: DateTime.parse(json['publicationDate'] as String),
      language: json['language'] as String,
      category: json['category'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      totalCopies: json['totalCopies'] as int,
      availableCopies: json['availableCopies'] as int,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'isbn': isbn,
      'title': title,
      'author': author,
      'description': description,
      'publicationDate': publicationDate.toIso8601String(),
      'language': language,
      'category': category,
      'coverImageUrl': coverImageUrl,
      'totalCopies': totalCopies,
      'availableCopies': availableCopies,
    };
  }

  // Create a copy with updated fields
  BookModel copyWith({
    String? id,
    String? isbn,
    String? title,
    String? author,
    String? description,
    DateTime? publicationDate,
    String? language,
    String? category,
    String? coverImageUrl,
    int? totalCopies,
    int? availableCopies,
  }) {
    return BookModel(
      id: id?? this.id,
      isbn: isbn ?? this.isbn,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      publicationDate: publicationDate ?? this.publicationDate,
      language: language ?? this.language,
      category: category ?? this.category,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      totalCopies: totalCopies ?? this.totalCopies,
      availableCopies: availableCopies ?? this.availableCopies,
    );
  }

  @override
  String toString() {
    return 'BookModel(isbn: $isbn, title: $title, author: $author, availableCopies: $availableCopies)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookModel && other.isbn == isbn;
  }

  @override
  int get hashCode => isbn.hashCode;
}