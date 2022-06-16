import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../config.dart';

class WinDialog extends StatelessWidget {
  const WinDialog({Key? key}) : super(key: key);

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
          DelayedDisplay(
            delay: const Duration(milliseconds: 500),
            child: Lottie.asset('assets/jsons/win.json',
                repeat: false, width: 230, height: 200),
          ),
          Text(
            "Correct !",
            style: GoogleFonts.getFont('Bungee',
                textStyle: const TextStyle(color: kPrimaryColor, fontSize: 22)),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/score.gif', width: 40, height: 40),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 6),
                child: Text(
                  "5",
                  style: GoogleFonts.getFont('Bungee',
                      textStyle: const TextStyle(
                          color: Color.fromARGB(167, 12, 84, 143),
                          fontSize: 32)),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
