import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salesforce/components/my_button.dart';
import 'package:salesforce/components/my_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future resetPasswordLinkInEmail() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );

    //try sign in
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );

      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reset Password'),
          content: const Text(
              'Reset Password link send. check you mail! if the email is registered in salesforce'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Thank you'),
            ),
          ],
        ),
      );

      // pop the loading circle
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.code),
          content: Text(
            e.message.toString(),
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.blueAccent[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Icon(
                Icons.lock_reset_rounded,
                size: 100,
              ),
            ),
            const Text(
              'Enter your Email and we will send the reset password link in your mail.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 25,
            ),
            MyTextField(
              fieldHintText: 'Email',
              suffixIcon: const Icon(Icons.admin_panel_settings),
              controler: emailController,
              obscureText: false,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              btName: 'Send Email',
              onTap: () => resetPasswordLinkInEmail(),
            ),
          ],
        ),
      ),
    );
  }
}
