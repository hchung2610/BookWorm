import 'package:flutter/material.dart';
import 'dart:async';
import 'drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Timer? _timer;
  Duration _duration = Duration();
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _loadTimerState();
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeMillis = prefs.getInt('startTimeMillis');
    final isRunning = prefs.getBool('isRunning') ?? false;
    final savedDuration = prefs.getInt('savedDuration') ?? 0;

    setState(() {
      _isRunning = isRunning;
      if (startTimeMillis != null && isRunning) {
        DateTime startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
        _duration = DateTime.now().difference(startTime);
        _startTimer();
      } else {
        _duration = Duration(seconds: savedDuration);
      }
    });
  }

  void _updateTimer() {
    if (_isRunning) {
      setState(() {
        _duration += Duration(seconds: 1);
      });
    }
  }

  void _startTimer() {
    final startTime = DateTime.now().subtract(_duration);
    _saveTimerState(startTime, true, _duration.inSeconds);
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTimer());
    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _saveTimerState(DateTime.now().subtract(_duration), false, _duration.inSeconds);
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _saveTimerState(DateTime.now(), false, 0);
    setState(() {
      _duration = Duration();
      _isRunning = false;
    });
  }

  Future<void> _saveTimerState(DateTime startTime, bool isRunning, int savedDuration) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startTimeMillis', startTime.millisecondsSinceEpoch);
    await prefs.setBool('isRunning', isRunning);
    await prefs.setInt('savedDuration', savedDuration);
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
              'Elapsed Time: ${_duration.inHours.toString().padLeft(2, '0')}:${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
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
                  onPressed: _isRunning ? null : _startTimer,
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
                    onPressed: _isRunning ? _stopTimer : null,
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
