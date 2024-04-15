// util/book.dart

class BookInfo {
  final String name;
  final String icon;

  BookInfo({required this.name, required this.icon});

  factory BookInfo.fromJson(Map<String, dynamic> json) {
    return BookInfo(
      name: json['title'] ?? 'Untitled',
      icon: json['imageLinks'] != null ? json['imageLinks']['thumbnail'] : '',
    );
  }
}
