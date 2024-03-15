import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salesforce/components/loading_animation.dart';
import 'package:salesforce/components/my_button.dart';
import 'package:salesforce/components/my_text_field.dart';
import 'package:salesforce/components/square_tile.dart';
import 'package:salesforce/screens/asm_page.dart';
import 'package:salesforce/screens/aso_page.dart';
import 'package:salesforce/screens/forgot_pw.dart';
import 'package:salesforce/screens/rsm_page.dart';
import 'package:salesforce/services/auth_services.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void singInUser() async {
    //show loading circle
    LoadingAnimation().getCircularProgressIndicatorCenter(context);

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      final userUID = currentUser!.uid;

      final dbRef = FirebaseDatabase.instance.ref().child("Employees");

      await dbRef.child(userUID).once().then(
        (event) {
          DataSnapshot snapshot = event.snapshot;
          // pop the loading circle
          Navigator.pop(context);

          setState(
            () {
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
        },
      );

      // If occured Error
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'invalid-email') {
        showErrorMsg(
          'Invalid Email',
          e.message.toString(),
        );
      } else if (e.code == 'invalid-credential') {
        showErrorMsg(
          'Invalid Login',
          "Make sure a Password is correct! or the Email is unregistered in salesforce.",
        );
      } else {
        showErrorMsg(
          'Error',
          e.message.toString(),
        );
      }
    }
  }

  void showErrorMsg(String errorMsg, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          errorMsg,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(content, style: const TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.lock,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Welcome back to Salesforce',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              MyTextField(
                fieldHintText: 'Email',
                suffixIcon: const Icon(Icons.admin_panel_settings),
                controler: emailController,
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                fieldHintText: 'Password',
                suffixIcon: const Icon(Icons.lock_outline_rounded),
                controler: passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot Password?  ",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              MyButton(btName: "Sign In", onTap: singInUser),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Or Continue with',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),

              // google and apple sign in

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google sign in

                  SquareTile(
                    imagePath: 'lib/assets/images/google.png',
                    onTap: () =>
                        AuthenticationServices().signInWithGoogle(context),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  //apple sign in
                  SquareTile(
                    imagePath: 'lib/assets/images/apple.png',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New Employee?',
                    style: TextStyle(
                        color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    'Register Now',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
