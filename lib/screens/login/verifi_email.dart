import 'dart:async';

import 'package:duolanguage/config.dart';
import 'package:duolanguage/screens/home.dart';
import 'package:duolanguage/screens/languages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../util/gradient_text.dart';

class EmailVerify extends StatefulWidget {
  final String email;
  const EmailVerify({Key? key, required this.email}) : super(key: key);

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
              context, MaterialPageRoute(builder: (context) => const Language()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        backgroundColor: kBackgroundColor,
        elevation: 0,
        toolbarHeight: 80,
        title: GradientText(
          "Email Verification",
          style: GoogleFonts.bungee(
            textStyle: const TextStyle(fontSize: 22),
          ),
          gradient: const LinearGradient(colors: [
            kPrimaryColor,
            kSeconderyColor,
          ]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Verification link sent to ",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(fontSize: 18),
                )),
            Text(" ${widget.email}",
                style: GoogleFonts.poppins(
                  textStyle:
                      const TextStyle(color: kPrimaryColor, fontSize: 16),
                )),
            Lottie.asset("assets/jsons/email.json"),
          ],
        ),
      ),
    );
  }
}
