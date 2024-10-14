import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  DateTime? selectedDate; // Variable to store the selected date
  final _noteController =
      TextEditingController(); // Controller for the note input
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int _notificationIdCounter = 0; // Counter for unique notification IDs

  @override
  void initState() {
    super.initState();
    _initializeNotifications(); // Initialize notifications when the app starts
    tz.initializeTimeZones(); // Initialize time zones for scheduling notifications
  }

  // Method to initialize notifications
  Future<void> _initializeNotifications() async {
    await _requestPermissions(); // Request notification permissions

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings); // Initialize the notification plugin
  }

  // Request permission to send notifications
  Future<void> _requestPermissions() async {
    await Permission.notification.request(); // Request notification permission
  }

  // Method to select a date from a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to current date
      firstDate: DateTime.now(), // Can't select a date before today
      lastDate: DateTime(2101), // Limit to year 2101
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.green,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    // If a date was picked, update the selectedDate variable
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Method to schedule a notification
  Future<void> _scheduleNotification() async {
    // Check if the note is empty or if no date is selected
    if (_noteController.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a note and select a date')),
      );
      return; // Exit the method if the validation fails
    }

    // Use the selected date and set the time to now + 1 minute for testing
    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      now.hour, // Keep the current hour
      now.minute + 1, // Set to 1 minute from now for immediate testing
    );

    // Convert selected date to a TZDateTime for scheduling
    final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

    print(
        'Scheduling notification at: $tzDateTime with note: ${_noteController.text}');

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      _notificationIdCounter++, // Increment the ID for each notification
      'Reminder', // Title of the notification
      _noteController.text, // Note text
      tzDateTime, // Time to schedule the notification
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.high, // High importance for immediate display
          priority: Priority.high, // High priority for notification
        ),
        iOS: DarwinNotificationDetails(), // iOS notification settings
      ),
      androidAllowWhileIdle:
          true, // Allow notification even if the device is idle
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification Scheduled')),
    );

    print('Notification scheduled successfully.'); // Log success
  }

  @override
  Widget build(BuildContext context) {
    // Display the selected date or a default message
    String dateText;
    if (selectedDate == null) {
      dateText = 'No Date Chosen!';
    } else {
      dateText = '${selectedDate!.toLocal()}'.split(' ')[0]; // Format the date
    }

    final screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 232, 232, 232), // Background color
      appBar: AppBar(
        title: const Text(
          'Select a Date',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display the selected date
              Text(
                'Selected Date: $dateText',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30), // Space between elements

              // Button to pick a date
              SizedBox(
                width: screenWidth * 0.8,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _selectDate(context), // Open date picker
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Pick a Date',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30), // Space between elements

              // Input field for the note
              SizedBox(
                width: screenWidth * 0.8,
                child: TextField(
                  controller: _noteController, // Controller for the note input
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Enter your note',
                    labelStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(), // Border style
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green, // Border color when enabled
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green, // Border color when focused
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30), // Space between elements

              // Button to schedule the notification
              ElevatedButton(
                onPressed:
                    _scheduleNotification, // Schedule notification on press
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Schedule Notification',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
