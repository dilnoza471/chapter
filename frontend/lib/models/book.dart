class Book{
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final bool isAvailable;
  final int totalCopies;
  final int availableCopies;

  Book({required this.id,
        required this.title,
        required this.author,
        required this.coverUrl,
        required this.isAvailable,
        this.totalCopies=1,
        this.availableCopies=0});
  
  Book copyWith({
    bool? isAvailable,
    int? availableCopies,
  }){
    return Book(
      id: id,
      title: title,
      author: author,
      coverUrl: coverUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      totalCopies: totalCopies,
      availableCopies: availableCopies ?? this.availableCopies,

    );
  }
}