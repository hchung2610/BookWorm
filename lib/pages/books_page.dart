import "package:flutter/material.dart";
import "package:practice_proj/pages/detailed_view.dart";
import "package:practice_proj/pages/filter_page.dart";
import "../util/book_card.dart";
import "drawer.dart";

import "explore_page.dart";

// books is the list containing the books in this page
List<String> filter_genres = [];
List<Book> filtered_books = books;
Set<String> unique_genres = {};
Set<String> unique_books = {};

class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  void filterBooks(int index) {
    setState(() {
      if (filter_genres.length == 0) {
        filtered_books = books;
      } else {
        for (int i = 0; i < filtered_books.length; i++) {
          if (!filter_genres
              .any((genre) => filtered_books[i].categories.contains(genre))) {
            filtered_books.remove(filtered_books[i]);
          }
        }
      }
    });
  }

  void removeBook(Book book) {
    setState(() {
      filtered_books.remove(book);
      book.isAdded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(filter_genres);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Books"),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              await Navigator.pushNamed(context, '/filter');
              setState(() {});
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: filtered_books
            .length, // Assumes 'books' is a global list of added books
        itemBuilder: (context, index) {
          Book curr_book = filtered_books[index];
          print(filtered_books[index].name +
              " " +
              filtered_books[index].categories.toString());
          if (unique_genres.add(filtered_books[index].categories[0])) {
            genres.add([filtered_books[index].categories[0].toString(), false]);
          }
          return BookCard(
            book: curr_book,
            onToggleAdded: () {
              // Opening the detailed view o tap
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedView(
                        title: curr_book.name,
                        author: curr_book.authors,
                        genre: curr_book.categories,
                        icon: curr_book.icon),
                  ));
            },
            onRemove: () => removeBook(filtered_books[index]),
            showActions: true,
          );
        },
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
