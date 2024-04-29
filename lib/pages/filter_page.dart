import 'package:flutter/material.dart';
import "package:practice_proj/util/book_card.dart";
import "package:practice_proj/util/button.dart";
import "package:practice_proj/util/genre_tile.dart";
import "package:practice_proj/pages/books_page.dart";

List genres = [];

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  void clearFilter() {
    setState(() {
      for (int i = 0; i < genres.length; i++) {
        genres[i][1] = false;
      }
      filter_genres.clear();
      applyFilter();
    });
  }

  void applyFilter() {
    setState(() {
      if (filter_genres.isEmpty) {
        filtered_books = books;
      } else {
        filtered_books = filtered_books
            .where((element) =>
                filter_genres.contains(element.categories[0].toString()))
            .toList();
      }
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // first filter

            Container(
                child: Column(children: [
              Text(
                "Genre",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GenreFilter()
            ])),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  text: "Apply",
                  onPressed: applyFilter,
                ),
                const SizedBox(
                  width: 8,
                ),
                Button(text: "Cancel", onPressed: clearFilter)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GenreFilter extends StatefulWidget {
  const GenreFilter({super.key});

  @override
  State<GenreFilter> createState() => _GenreFilterState();
}

class _GenreFilterState extends State<GenreFilter> {
  void checkBoxChanged(int index, bool? val) {
    setState(() {
      genres[index][1] = !genres[index][1];
      genres[index][1]
          ? filter_genres.add(genres[index][0])
          : filter_genres.remove(genres[index][0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) {
      return Padding(
          padding: EdgeInsets.all(30), child: Text("No Books In Library"));
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: genres.length,
          itemBuilder: (context, index) {
            return GenreTile(
                name: genres[index][0],
                checked: genres[index][1],
                onChanged: (val) => checkBoxChanged(index, val));
          });
    }
  }
}
