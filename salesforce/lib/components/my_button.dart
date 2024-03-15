import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.btName, required this.onTap});

  final Function()? onTap;
  final String btName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 320,
        height: 55,
        child: ElevatedButton(
          onPressed: onTap,
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.blue),
            elevation: MaterialStatePropertyAll(10),
          ),
          child: Text(
            btName,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
