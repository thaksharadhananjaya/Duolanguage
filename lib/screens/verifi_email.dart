import 'dart:async';

import 'package:duolanguage/config.dart';
import 'package:duolanguage/screens/quiz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerify extends StatefulWidget {
  
  const EmailVerify({Key? key}) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void startTimer() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer timer) async {
        final User? user = auth.currentUser;
        await user?.reload();
        if (user!.emailVerified) {
          timer.cancel();
          if (!mounted) return;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Quiz()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
