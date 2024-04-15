//this is the drawer class, its been imported into all the pages

import 'package:flutter/material.dart';
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.amber,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Icon(Icons.menu_book, size: 100),
                Text("Welcome John Smith!"),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("E X P L O R E"),
            onTap: () {
              Navigator.pushNamed(context, '/explore');
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text("B O O K S"),
            onTap: () {
              Navigator.pushNamed(context, '/books');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("S E T T I N G S"),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("P R O F I L E"),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}
