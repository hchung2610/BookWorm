import 'package:flutter/material.dart';

class DetailedView extends StatefulWidget {
  final String title;
  final List<String> author;
  final List<String> genre;
  final String icon;
  const DetailedView(
      {super.key,
      required this.title,
      required this.author,
      required this.genre,
      required this.icon});

  @override
  State<DetailedView> createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Book Details"),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.book)),
            Tab(icon: Icon(Icons.sticky_note_2)),
            Tab(icon: Icon(Icons.spellcheck)),
          ]),
        ),
        body: TabBarView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  Stack(children: [
                    Text(
                      "Title: ",
                      style: TextStyle(fontSize: 22),
                    ),
                    Center(
                        child: Text(
                      widget.title,
                      style: TextStyle(fontSize: 22),
                    )),
                  ]),
                  Row(children: [
                    Text(
                      "Author(s): ",
                      style: TextStyle(fontSize: 22),
                    ),
                    Expanded(
                        child: Text(
                      widget.author.toString(),
                      style: TextStyle(fontSize: 22),
                    )),
                  ]),
                  Stack(children: [
                    Text(
                      "Genre(s): ",
                      style: TextStyle(fontSize: 22),
                    ),
                    Center(
                        child: Text(
                      widget.genre.toString(),
                      style: TextStyle(fontSize: 22),
                    )),
                  ]),
                ],
              ),
            ),
            Tab(icon: Icon(Icons.sticky_note_2)),
            Tab(icon: Icon(Icons.spellcheck)),
          ],
        ),
      ),
    );
  }
}
