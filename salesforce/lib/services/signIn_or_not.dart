import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salesforce/screens/asm_page.dart';
import 'package:salesforce/screens/aso_page.dart';
import 'package:salesforce/screens/login_page.dart';
import 'package:salesforce/screens/rsm_page.dart';
import 'package:salesforce/screens/starting_loading_screen.dart';

class SignInOrNot extends StatelessWidget {
  const SignInOrNot({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> user) {
        if (user.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (user.hasData) {
          final currentUser = FirebaseAuth.instance.currentUser;
          final userUID = currentUser!.uid;

          final dbRef = FirebaseDatabase.instance.ref().child("Employees");

          dbRef.child(userUID).once().then(
            (event) {
              DataSnapshot snapshot = event.snapshot;

              Map<Object?, Object?> dataMap =
                  snapshot.value as Map<Object?, Object?>;
              String userRole = dataMap['Role'] as String;

              if (userRole == "RSM") {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const RSM()));
              } else if (userRole == "ASM") {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const ASM()));
              } else if (userRole == "ASO") {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const ASO()));
              }
            },
          );
        } else {
          return const LogInPage();
        }

        return const Center(
          child: StartingLoadingScreen(),
        );
      },
    );
  }
}
