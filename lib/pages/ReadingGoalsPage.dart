import 'package:flutter/material.dart';
import 'books_page.dart'; // Import where filtered_books is defined
import 'package:shared_preferences/shared_preferences.dart';

class ReadingGoalsPage extends StatefulWidget {
  const ReadingGoalsPage({Key? key}) : super(key: key);

  @override
  _ReadingGoalsPageState createState() => _ReadingGoalsPageState();
}

class _ReadingGoalsPageState extends State<ReadingGoalsPage> {
  int goal = 10; // Default yearly goal
  int booksRead = 0; // Initialize booksRead

  @override
  void initState() {
    super.initState();
    _loadFinishedBooks();
  }

  void _loadFinishedBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> finishedBooks = prefs.getStringList('finishedBooks') ?? [];
    int savedGoal = prefs.getInt('readingGoal') ?? 10;
    setState(() {
      booksRead =
          finishedBooks.length; // Set booksRead based on finishedBooks list
      goal = savedGoal;
    });
  }

  void _updateGoal(String value) async {
    int newGoal = int.tryParse(value) ?? goal;
    if (newGoal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a positive number.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (newGoal != goal) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('readingGoal', newGoal);
      setState(() {
        goal = newGoal; // Update the goal and save to prefs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Goals'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Set your reading goal for the year:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter number of books as your goal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: _updateGoal,
            ),
            const SizedBox(height: 20),
            Text(
              'Progress to goal:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: booksRead / goal,
              backgroundColor: Theme.of(context).colorScheme.scrim,
              color: Theme.of(context).colorScheme.tertiary,
              minHeight: 20,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20),
            //   child: Text(
            //     'You have read $booksRead books out of $goal. \n${goal - booksRead} books left to reach your goal!',
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: booksRead < goal
                  ? RichText(
                      textAlign: TextAlign.center, // Aligns text to the center
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                        ), // Default text style
                        children: [
                          TextSpan(
                              text:
                                  'Fantastic!\n You\'ve read $booksRead (book/books) out of $goal this year.\n ${goal - booksRead} books left to reach your goal!\n',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                          TextSpan(
                            text:
                                '\nKeep up the great work!', // New line before this part
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          'Congratulations! 🎉',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        SizedBox(
                            height:
                                10), // Adds a small space between the two texts
                        Text(
                          'You’ve achieved your goal of reading $goal books this year. Amazing effort!',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
