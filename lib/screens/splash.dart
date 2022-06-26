import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../config.dart';
import '../util/gradient_text.dart';

class Spalsh extends StatefulWidget {
  Spalsh({Key? key}) : super(key: key);

  @override
  State<Spalsh> createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  late final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/jsons/logo.json",
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 8,
            ),
            GradientText(
              "Duolanguage",
              style: GoogleFonts.poppins(
                textStyle:
                    const TextStyle(fontSize: 17),
              ),
              gradient: const LinearGradient(colors: [
                kPrimaryColor,
                kSeconderyColor,
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
