class Book {
  final String name;
  final String icon;
  final List<String> authors;
  final List<String> categories;
  bool isAdded;
  int rating;

  Book(
      {required this.name,
      required this.icon,
      required this.authors,
      required this.categories,
      this.isAdded = false,
      this.rating = 1});

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> parseAuthors(json) {
      return json['authors'] != null ? List<String>.from(json['authors']) : [];
    }

    List<String> parseCategories(json) {
      return json['categories'] != null
          ? List<String>.from(json['categories'])
          : [];
    }

    int defaultRating = 1;

    return Book(
      name: json['title'] ?? 'Untitled',
      icon: json['imageLinks'] != null ? json['imageLinks']['thumbnail'] : '',
      authors: parseAuthors(json),
      categories: parseCategories(json),
      isAdded: json['isAdded'] ?? false,
      rating: json['rating'] ?? defaultRating,
    );
  }
}
