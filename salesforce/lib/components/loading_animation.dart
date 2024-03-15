import 'package:flutter/material.dart';

class LoadingAnimation {
  void getCircularProgressIndicatorCenter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );
  }
}
