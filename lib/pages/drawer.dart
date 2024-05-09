//this is the drawer class, its been imported into all the pages
import 'package:flutter/material.dart';
import 'package:practice_proj/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userName = "User"; // Default name

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('userName');
    setState(() {
      userName = savedName ?? "User"; // Use "User" if no name is found
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Text(
                  "B o o k W o r m",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.menu_book, size: 80),
                Text("Welcome $userName!"),
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
            leading: Icon(Icons.timer),
            title: Text("T I M E R"),
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
          SwitchListTile(
            title: Text(
              "Dark Mode",
            ),
            value: Provider.of<ThemeProvider>(context).isDark,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            activeColor: Theme.of(context).colorScheme.tertiary,
            inactiveTrackColor: Theme.of(context).colorScheme.scrim,
            inactiveThumbColor: Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}
