import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salesforce/components/loading_animation.dart';
import 'package:salesforce/screens/asm_page.dart';
import 'package:salesforce/screens/aso_page.dart';
import 'package:salesforce/screens/rsm_page.dart';

class AuthenticationServices {
  signInWithGoogle(BuildContext context) async {
    //circular progress indecator start
    LoadingAnimation().getCircularProgressIndicatorCenter(context);

    await GoogleSignIn().signOut();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    final currentUser = FirebaseAuth.instance.currentUser;
    final userUid = currentUser!.uid;
    final dbRef = FirebaseDatabase.instance.ref().child('Employees');

    await dbRef.child(userUid).once().then(
      (event) {
        DataSnapshot snapshot = event.snapshot;

        Map<Object?, Object?> dataMap = snapshot.value as Map<Object?, Object?>;
        String userRole = dataMap['Role'] as String;

        //remove circular progress indicator.
        Navigator.pop(context);

        if (userRole == "RSM") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const RSM()));
        } else if (userRole == "ASM") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const ASM()));
        } else if (userRole == "ASO") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const ASO()));
        }
      },
    );
  }
}
