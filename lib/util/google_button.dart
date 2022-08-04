import 'package:duolanguage/screens/home.dart';
import 'package:duolanguage/screens/languages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/authentication.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton({Key? key}) : super(key: key);

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool progress = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: progress
          ? null
          : () async {
              setState(() {
                progress = true;
              });
              User? user =
                  await Authentication.signInWithGoogle(context: context);
              if (!mounted) return;
              if (user != null) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Language()));
              }
              setState(() {
                progress = false;
              });

              // await Authentication.signOut(context: context);
            },
      child: SizedBox(
        height: 50,
        child: Card(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: progress
                  ? const SizedBox(
                      width: 26, height: 26, child: CircularProgressIndicator())
                  : Image.asset(
                      "assets/images/google.png",
                      width: 30,
                      height: 30,
                    ),
            )),
      ),
    );
  }
}
