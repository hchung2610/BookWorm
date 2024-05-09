import 'package:flutter/material.dart';
import 'package:practice_proj/pages/books_page.dart';
import 'package:practice_proj/pages/filter_page.dart';
import 'package:practice_proj/theme/theme.dart';
import 'package:practice_proj/theme/theme_provider.dart';
import 'package:practice_proj/util/library_model.dart';
import 'package:provider/provider.dart';
import 'pages/settings_page.dart';
import 'pages/profile_page.dart';
import 'pages/explore_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LibraryModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: ExplorePage(),
      routes: {
        '/explore': (context) => ExplorePage(),
        '/books': (context) => BooksPage(),
        '/settings': (context) => SettingsPage(),
        '/profile': (context) => ProfilePage(),
        '/filter': (context) => FilterPage(),
      },
    );
  }
}
