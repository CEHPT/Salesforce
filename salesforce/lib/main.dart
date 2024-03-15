import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:salesforce/api/firebase_api.dart';
import 'package:salesforce/services/signIn_or_not.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // this is for FCM messaging
  await FirebaseApi().initNotification();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salesforce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const SignInOrNot(),
    );
  }
}
