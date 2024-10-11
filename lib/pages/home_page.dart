import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 232, 232, 232),
        body: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centers the content vertically
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 50), // Moves text a little up
                child: Text(
                  "Welcome to our App 👋🏼",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers buttons horizontally
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the notification page
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
                  const SizedBox(
                      width: 20), // Adds space between the two buttons
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the timer page
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
      ),
    );
  }
}
