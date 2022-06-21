import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use' ||
            e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.buildCustomSnakBar(
              'The email address is already in use by another account.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.buildCustomSnakBar(
              'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    }

    return user;
  }

  static Future<User?> signUpWithEmail(
      {required BuildContext context,
      required String email,
      required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      user?.sendEmailVerification();
      await user?.updateDisplayName(user.email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use' ||
          e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.buildCustomSnakBar(
            'The email address is already in use by another account.',
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.buildCustomSnakBar(
            'Error occurred while accessing credentials. Try again.',
          ),
        );
      }
    }
    return user;
  }

  static Future<User?> signInWithEmailAndPassword({
     required BuildContext context,
      required String email,
      required String password
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user=userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.buildCustomSnakBar(
            'Wrong email or password !',
          ),
        );
      }
    }
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.buildCustomSnakBar(
          'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<bool> updateUserName(String name) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.currentUser?.updateDisplayName(name); //added this line
      await auth.currentUser?.reload();
      return true;
    } catch (e) {
      //print(e.toString());
      return false;
    }
  }

  static SnackBar buildCustomSnakBar(String content) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
