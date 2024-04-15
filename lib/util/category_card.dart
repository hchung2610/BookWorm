import 'package:flutter/material.dart';

class Category {
  final String name;
  final String icon;

  Category({required this.name, required this.icon});
}

List<Category> categories = [
  // Category(name: 'Science', icon: 'assets/icons/science.png'),
  // Category(name: 'History', icon: 'assets/icons/history.png'),
  // Category(name: 'Fiction', icon: 'assets/icons/fiction.png'),
  // // Add more categories here
];

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({required this.category});

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
            Image.asset(category.icon, width: 50, height: 50),
            Text(category.name),
          ],
        ),
      ),
    );
  }
}
