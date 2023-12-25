import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/widgets/default_textfiled.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final CollectionReference _tasks =
      FirebaseFirestore.instance.collection('tasks');

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(
        message.notification?.title ?? 'Notification',
        message.notification?.body ?? '',
      );
    });
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');
    final InitializationSettings initializationSettings =
        const InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String dateVal = DateFormat('dd/MM/yyyy').format(date);
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.brown,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 30,
          bottom: 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextField(
              controller: _titleController,
              hintText: 'Title',
            ),
            const SizedBox(
              height: 15,
            ),
            DefaultTextField(
              controller: _descriptionController,
              hintText: 'Description',
            ),
            const SizedBox(
              height: 15,
            ),
            DefaultTextField(
              controller: _dateController,
              hintText: 'Due Date(dd/MM/yyyy)',
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // Set border radius here
                  ),
                  primary: Colors.red, // Set the button color to red
                ),
                child: const Text('Submit'),
                onPressed: () async {
                  final String title = _titleController.text;
                  final String description = _descriptionController.text;
                  final String date = _dateController.text;
                  if (title != null) {
                    await _tasks.add({
                      "title": title,
                      "description": description,
                      "date": date,
                      'completed': false
                    }).then((value) {
                      sendNotificationFromFrontend(title);
                    });
                    _titleController.text = '';
                    _descriptionController.text = '';
                    _dateController.text = '';
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendNotificationFromFrontend(String messageText) async {
    await _firebaseMessaging.subscribeToTopic('allDevices');
    _showNotification('New Task is Added', messageText);
  }
}
