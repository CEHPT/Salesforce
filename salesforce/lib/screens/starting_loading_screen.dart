import 'package:flutter/material.dart';

class StartingLoadingScreen extends StatelessWidget {
  const StartingLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'lib/assets/images/salesforce-logo.png',
          height: 400,
          width: 400,
        ),
      ),
    );
  }
}
