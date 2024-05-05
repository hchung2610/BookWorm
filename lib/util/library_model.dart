import "package:flutter/material.dart";
import "package:practice_proj/util/book.dart";

class LibraryModel extends ChangeNotifier {
  // list of books that goes in the book libray
  List<Book> books = [];

  List genres = [];
  // List of genres that the books in the library have
  List<String> filter_genres = [];
  // The new list of books that contains the filtered books
  List<Book> filtered_books = [];
  // Use these sets to remove duplicates from their corresponding lists
  Set<String> unique_genres = {};
  Set<String> unique_books = {};

  void addBook(Book book, context) {
    if (unique_books.add(book.name)) {
      books.add(book);
      filtered_books = books;
      Navigator.pop(context);
    } else {
      final snackbar =
          SnackBar(content: const Text('Error: Cannot Add Existing Book'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    notifyListeners();
  }

  void removeBook(Book book) {
    books.remove(book);
    filtered_books.remove(book);
    notifyListeners();
  }

  void clearFilter(context) {
    for (int i = 0; i < genres.length; i++) {
      genres[i][1] = false;
    }
    filter_genres.clear();
    applyFilter(context);
    notifyListeners();
  }

  void applyFilter(context) {
    if (filter_genres.isEmpty) {
      filtered_books = books;
    } else {
      filtered_books = filtered_books
          .where((element) =>
              filter_genres.contains(element.categories[0].toString()))
          .toList();
    }
    Navigator.of(context).pop();
    notifyListeners();
  }

  void checkBoxChanged(int index, bool? val) {
    genres[index][1] = !genres[index][1];
    genres[index][1]
        ? filter_genres.add(genres[index][0])
        : filter_genres.remove(genres[index][0]);
    notifyListeners();
  }
}
