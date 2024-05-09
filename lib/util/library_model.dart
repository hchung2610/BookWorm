import "package:flutter/material.dart";
import "package:practice_proj/pages/explore_page.dart";
import "package:practice_proj/util/book.dart";

class LibraryModel extends ChangeNotifier {
  // list of books that goes in the book libray
  List<Book> books = [];
  Map<String, int> genreCounts = {};

  List genres = [];
  // List of genres that the books in the library have
  List<String> filter_genres = [];
  // The new list of books that contains the filtered books
  List<Book> filtered_books = [];
  // Use these sets to remove duplicates from their corresponding lists
  Set<String> unique_books = {};

  void toggleFinished(int index) {
    filtered_books[index].readStatus = !filtered_books[index].readStatus;

    notifyListeners();
  }

  void setStars(int index, int stars) {
    filtered_books[index].rating = stars;

    notifyListeners();
  }

  void addBook(Book book, context) {
    if (unique_books.add(book.name)) {
      books.add(book);
      filtered_books.add(book);
      for (var genre in book.categories) {
        genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
        if (genreCounts[genre] == 1 && genres.every((g) => g[0] != genre)) {
          genres.add([genre, false]);
        }
      }
      Navigator.pop(context);
    } else {
      final snackbar =
          SnackBar(content: const Text('Error: Cannot Add Existing Book'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    notifyListeners();
  }

  void removeBook(Book book) {
    for (var category in book.categories.toSet()) {
      // Ensure category count is initialized to zero if it's null
      genreCounts[category] ??= 0;

      // Decrement the category count
      genreCounts[category] = genreCounts[category]! - 1;

      // Remove the category if its count reaches zero
      if (genreCounts[category] == 0) {
        genreCounts.remove(category);
        globalAddedCategories.remove(category);
      }
    }

    unique_books.remove(book.name);
    genres.remove(book);
    books.remove(book);
    filtered_books.remove(book);

    // Update genres list after removing a book
    updateGenres();

    notifyListeners();
  }

  void updateGenres() {
    Set<String> currentGenres = {};

    // Collect all genres from the remaining books
    for (var book in books) {
      currentGenres.addAll(book.categories);
    }
    // Update the main genres list, removing genres that no longer have associated books
    genres.removeWhere((genre) => !currentGenres.contains(genre[0]));
  }

  void clearFilter(context) {
    for (int i = 0; i < genres.length; i++) {
      genres[i][1] = false;
    }
    filter_genres.clear();
    applyFilter(context);
    notifyListeners();
  }

  void applyFilter(BuildContext context) {
    if (filter_genres.isEmpty) {
      filtered_books = List<Book>.from(books);
    } else {
      filtered_books = books
          .where((book) =>
              book.categories.any((genre) => filter_genres.contains(genre)))
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
