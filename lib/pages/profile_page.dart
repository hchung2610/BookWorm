import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practice_proj/pages/books_page.dart';
import 'package:practice_proj/util/library_model.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ReadingGoalsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_launcher/url_launcher.dart';

File? _image;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  final TextEditingController _nameController = TextEditingController();
  bool _isLoggedIn = false;

  Future<void> _loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      setState(() {
        _isLoggedIn = true;
      });
      _redirectToFacebookGroup();
    } else {
      // Handle error or cancellation
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook login failed: ${result.message}'))
      );
    }
  }

  void _redirectToFacebookGroup() async{
    const url = 'https://www.facebook.com/groups/7048925028497413';
    if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
    } else {
    throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('userName');
    if (savedName != null) {
      _nameController.text = savedName;
    }
  }

  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  // Function to handle image picking
  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle exceptions or errors if any
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryModel>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.amber,
          elevation: 0,
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.camera_alt,
                          size: 80, color: Colors.grey.shade800)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Change Profile Picture'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                  onSubmitted: (value) {
                    _saveName(value);
                  },
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You have ' +
                    value.filtered_books.length.toString() +
                    " books in your library.",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text(
                  'Reading Goals',
                  style: TextStyle(fontSize: 20),
                ),
                leading: const Icon(
                  Icons.emoji_events,
                  color: Color.fromARGB(255, 31, 154, 88),
                  size: 30,
                ),
                onTap: () {
                  // Navigate to book history page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReadingGoalsPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Connect with Community', style: TextStyle(fontSize: 20)),
                leading: Icon(Icons.groups, color: Colors.blue, size: 30),
                onTap: _isLoggedIn ? _redirectToFacebookGroup : _loginWithFacebook,
              ),
              ListTile(
                title: Text('Dark Mode'),
                trailing: Switch(
                  value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);
                  },
                ),
                leading: const Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: 30,
                ),
                onTap: () {
                  // Navigate to settings page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;  // Start with system default

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

