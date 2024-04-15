import 'package:flutter/material.dart';

class Book {
  final String name;
  final String icon;

  Book({required this.name, required this.icon});
}

List<Book> books = [
  Book(name: 'Science', icon: 'assets/icons/science.png'),
  Book(name: 'History', icon: 'assets/icons/history.jpg'),
  Book(name: 'Fiction', icon: 'assets/icons/fiction.png'),

  // Add more books here
];

class BookCard extends StatelessWidget {
  final Book book;

  BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Handle the tap
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(book.icon, width: 50, height: 50),
            Text(book.name),
          ],
        ),
      ),
    );
  }
}
