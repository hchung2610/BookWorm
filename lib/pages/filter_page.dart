import 'package:flutter/material.dart';
import "package:practice_proj/util/button.dart";
import "package:practice_proj/util/genre_tile.dart";
import "package:practice_proj/util/library_model.dart";
import "package:provider/provider.dart";

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryModel>(
      builder: (contextLibrary, value, child) => Scaffold(
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
                    onPressed: () {
                      final library = contextLibrary.read<LibraryModel>();
                      library.applyFilter(context);
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Button(
                      text: "Cancel",
                      onPressed: () {
                        final library = contextLibrary.read<LibraryModel>();
                        library.clearFilter(context);
                      })
                ],
              )
            ],
          ),
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
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryModel>(
        builder: (contextLibrary, value, child) => value.genres.isEmpty
            ? Padding(
                padding: EdgeInsets.all(30), child: Text("No Genres Available"))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: value.genres.length,
                itemBuilder: (context, index) {
                  return GenreTile(
                      name: value.genres[index][0],
                      checked: value.genres[index][1],
                      onChanged: (val) {
                        final library = contextLibrary.read<LibraryModel>();
                        //library.checkBoxChanged(index, val);
                      });
                },
              ));
  }
}
