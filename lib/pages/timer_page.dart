// the user will press start and the program will start until 20min,
// after that will send a notification to take a 5min break.
import 'package:flutter/material.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: const Center(
        child: Text(
          'This is the Timer Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
