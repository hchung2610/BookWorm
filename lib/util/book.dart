class Book {
  final String name;
  final String icon;
  final List<String> authors;
  final List<String> categories;
  int index;
  int rating;
  bool readStatus;

  Book(
      {required this.name,
      required this.icon,
      required this.authors,
      required this.categories,
      required this.rating,
      required this.readStatus,
      required this.index});

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> parseAuthors(json) {
      return json['authors'] != null ? List<String>.from(json['authors']) : [];
    }

    List<String> parseCategories(json) {
      return json['categories'] != null
          ? List<String>.from(json['categories'])
          : [];
    }

    return Book(
      name: json['title'] ?? 'Untitled',
      icon: json['imageLinks'] != null ? json['imageLinks']['thumbnail'] : '',
      authors: parseAuthors(json),
      categories: parseCategories(json),
      rating: 0,
      readStatus: false,
      index: 0,
    );
  }
}
