import 'package:flutter/material.dart';
import 'package:pomonote/pages/notification_page.dart';
import 'package:pomonote/pages/timer_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationPage()),
    );
  }

  void _navigateToTimer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TimerPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      body: SafeArea(
        // Use SafeArea to avoid the device's status bar overlap
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align children at the top
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align to the start (left)
          children: [
            const SizedBox(height: 20), // Add some space at the top
            Row(
              children: [
                Container(
                  child: const Text(
                      "Welcome"), // Add "const" for Text since it is constant
                  padding: const EdgeInsets.all(
                      8.0), // Optional: Add padding inside the container
                ),
              ],
            ),
          ],
        ),
      ),

      /*
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                "Welcome to our App 👋🏼",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _navigateToNotifications(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Notifications'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _navigateToTimer(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Timer'),
                ),
              ],
            ),
          ],
        ),
      ),
      */
    );
  }
}
