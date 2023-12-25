import 'dart:io';
import 'package:firebase_application/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'notification/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyB5Q2YpBzy3AP06soUhdxrx6vTZIYhOaqY',
      appId: '1:621709065273:android:bdb9f9453cd72f6bdaa1e8',
      messagingSenderId: '621709065273',
      projectId: 'fir-application-d0941',
    ));
    await initNotifications();
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: Colors.redAccent),
      debugShowCheckedModeBanner: false,
      title: 'Firebase Firestore',
      //home: const DemoClass(),
      // home: const SignupScreen(),
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();



