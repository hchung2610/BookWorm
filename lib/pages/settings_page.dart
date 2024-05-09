import 'package:flutter/material.dart';
import 'dart:async'; // Import async library for Timer
import 'drawer.dart'; // Assuming this is correctly implemented

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Timer? _timer;
  Duration _duration = Duration();

  void _startTimer() {
    // Prevent multiple timers running simultaneously
    if (_timer != null) {
      _timer!.cancel();
    }
    // Start counting up
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration = _duration + Duration(seconds: 1);
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _timer = null;
      });
    }
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _duration = Duration();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Reading Time: ${_duration.inHours.toString().padLeft(2, '0')}:${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text(
                    'Start',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: _stopTimer,
                    child: Text(
                      'Stop',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                    )),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
