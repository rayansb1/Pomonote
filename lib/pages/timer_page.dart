import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _workTime = 5; //25 * 60;
  int _breakTime = 5; //5 * 60;
  bool _isWork = true;
  bool _isRunning = false;
  String _buttonText = "Start Timer";
  int _cyclesCompleted = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    requestIOSPermissions();
  }

  void initializeNotifications() async {
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    String? payload = notificationResponse.payload;
    if (payload != null) {
      developer.log('Notification payload: $payload');
    }
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  void _startOrPauseTimer() {
    setState(() {
      if (_isRunning) {
        // Pause the timer
        _timer?.cancel();
        _buttonText = "Start Timer";
      } else {
        // Start or resume the timer
        _buttonText = "Pause Timer";
        if (_isWork) {
          _startWorkTimer();
        } else {
          _startBreakTimer();
        }
      }
      _isRunning = !_isRunning;
    });
  }

  void _startWorkTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_workTime > 0) {
          _workTime--;
        } else {
          _timer?.cancel();
          if (_cyclesCompleted < 3) {
            _showNotification("Work Finished", "Time for a 5-minute break!");
            _isWork = false;
            _isRunning = true;
            _buttonText = "Pause Break";
            _breakTime = 5; //5 * 60;
            _startBreakTimer(); // Automatically start break timer
          } else {
            _cyclesCompleted++;
            _showGreatWorkDialog(); // Show the completion dialog
          }
        }
      });
    });
  }

  void _startBreakTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_breakTime > 0) {
          _breakTime--;
        } else {
          _timer?.cancel();
          _cyclesCompleted++;
          if (_cyclesCompleted >= 4) {
            _showGreatWorkDialog();
          } else {
            _showNotification(
                "Break Finished", "Starting next Pomodoro session.");
            _isWork = true;
            _isRunning = true;
            _buttonText = "Pause Work";
            _workTime = 5; //25 * 60; // Reset work time to 25 minutes
            _startWorkTimer();
          }
        }
      });
    });
  }

  void _showGreatWorkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Great Work!'),
        content: const Text('You have completed 4 Pomodoro cycles.'),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Start Again'),
            ),
          ),
        ],
      ),
    );
  }

  void _resetTimer() {
    setState(() {
      _workTime = 5; //25 * 60;
      _breakTime = 5; //5 * 60;
      _cyclesCompleted = 0;
      _buttonText = "Start Timer";
      _isRunning = false;
      _isWork = true;
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'pomodoro_channel', // channel id
      'Pomodoro Timer', // channel name
      channelDescription: 'Pomodoro timer notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pomodoro Timer",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 232, 232, 232),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              _isWork ? "Work Timer ⏰" : "Break Timer ⏳",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isWork
                  ? "${(_workTime ~/ 60).toString().padLeft(2, '0')}:${(_workTime % 60).toString().padLeft(2, '0')}"
                  : "${(_breakTime ~/ 60).toString().padLeft(2, '0')}:${(_breakTime % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startOrPauseTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(_buttonText),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
