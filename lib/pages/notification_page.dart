// the user will just choose the date and the note he want to recive it in the selected date.
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text(
          'This is the Notifications Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
