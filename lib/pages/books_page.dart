import "dart:math";

import "package:flutter/material.dart";
import "package:practice_proj/pages/detailed_view.dart";
import "package:practice_proj/util/book.dart";
import "package:practice_proj/util/library_book_card.dart";
import "package:practice_proj/util/library_model.dart";
import "package:provider/provider.dart";
import "drawer.dart";

import "explore_page.dart";

class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryModel>(
      builder: (contextLibrary, value, child) => Scaffold(
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
        body: Column(
          children: [
            Container(
              height: 50, // Fixed height for the genre bar
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: globalAddedCategories.map((genre) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: ActionChip(
                        label: Text(genre),
                        onPressed: () {
                          // Implement your action for filtering books based on the genre
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: value.filtered_books.length, // Assumes 'filtered_books' is a list of filtered books in LibraryModel
                itemBuilder: (context, index) {
                  Book curr_book = value.filtered_books[index];

                  return LibraryBookCard(
                    book: curr_book,
                    finished: false,
                    showDetails: () {
                      // Opening the detailed view on tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedView(
                            book: curr_book,
                            title: curr_book.name,
                            author: curr_book.authors,
                            genre: curr_book.categories,
                            icon: curr_book.icon,
                            isFinished: false,
                          ),
                        ),
                      );
                    },
                    onRemove: () {
                      final library = contextLibrary.read<LibraryModel>();
                      library.removeBook(value.filtered_books[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
