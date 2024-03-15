import 'package:flutter/material.dart';

class PresentAbsentDialog {
  Future<bool> presentOrAbsentDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.lightBlue.shade100,
        title: const Text('Present'),
        content: const Text(
          "Hi! have a nice day , Are you present or absent today?",
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Absent"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yeah. I am Present"),
          ),
        ],
      ),
    );
  }
}
