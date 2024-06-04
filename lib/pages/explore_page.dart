import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practice_proj/pages/books_page.dart';
import 'package:practice_proj/pages/detailed_view.dart';
import 'package:practice_proj/util/book.dart';
import 'package:practice_proj/util/library_model.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'drawer.dart';
import '../util/explore_book_card.dart';
import 'config.dart';

List<String> globalAddedCategories = [];

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Future<List<Book>> futureBooks;
  final TextEditingController searchController = TextEditingController();
  List<String> addedCategories = [];
  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks("books");
  }

  Future<List<Book>> fetchBooks(String query) async {
    final url = Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=10&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['totalItems'] > 0) {
        return (data['items'] as List)
            .map((item) => Book.fromJson(item['volumeInfo']))
            .toList();
      } else {
        throw Exception('No books found');
      }
    } else {
      throw Exception('Failed to load books');
    }
  }

  void updateSearchQuery(String newQuery) {
    if (newQuery.isNotEmpty) {
      setState(() {
        futureBooks = fetchBooks(newQuery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryModel>(
      builder: (contextLibrary, value, child) => Scaffold(
        appBar: AppBar(
          title: Text("Explore"),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
        ),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search books',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => updateSearchQuery(searchController.text),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                onSubmitted: updateSearchQuery,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: futureBooks,
                builder: (contextLibrary, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      padding: EdgeInsets.all(10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Book book = snapshot.data![index];

                        return ExploreBookCard(
                          book: book,
                          addBook: () {
                            // getting access to the library model class

                            final library = contextLibrary.read<LibraryModel>();

                            if (book.categories.isNotEmpty) {
                              // Check if the categories are not already added
                              if (!addedCategories
                                  .contains(book.categories[0].toString())) {
                                // Add categories to the global list
                                addedCategories
                                    .add(book.categories[0].toString());

                                if (!globalAddedCategories
                                    .contains(addedCategories.last)) {
                                  globalAddedCategories
                                      .add(addedCategories.last);
                                }
                              }
                            }
                            library.addBook(book, context);
                          },
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("No books available."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
