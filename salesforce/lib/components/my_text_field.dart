import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.fieldHintText,
      required this.suffixIcon,
      required this.controler,
      required this.obscureText});

  final String fieldHintText;
  final Widget suffixIcon;
  final TextEditingController? controler;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        decoration: InputDecoration(
          suffix: suffixIcon,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: fieldHintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
        ),
        obscureText: obscureText,
        controller: controler,
      ),
    );
  }
}
