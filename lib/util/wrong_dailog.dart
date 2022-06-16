import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../config.dart';

class WrongDialog extends StatelessWidget {
  const WrongDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SizedBox(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 24,
          ),
          DelayedDisplay(
            delay: const Duration(milliseconds: 200),
            child: Lottie.asset('assets/jsons/wrong.json',
                width: 100, height: 100),
          ),
          const SizedBox(
            height: 36,
          ),
          DelayedDisplay(
            delay: const Duration(milliseconds: 400),
            child: Text(
              "Try Again !",
              style: GoogleFonts.getFont('Bungee',
                  textStyle:
                      const TextStyle(color: kSeconderyColor, fontSize: 22)),
            ),
          ),
        ],
      )),
    );
  }
}
