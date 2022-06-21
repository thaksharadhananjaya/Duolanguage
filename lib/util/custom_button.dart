

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pushable_button/pushable_button.dart';

import '../config.dart';

class CustomButton extends StatelessWidget {
  final Function onPress;
  final String label;
  final double width;
  const CustomButton({Key? key, required this.onPress, required this.label, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: PushableButton(
        height: 48,
        elevation: 5,
        hslColor: HSLColor.fromColor(kSeconderyColor),
        shadow: BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
        onPressed: ()=> onPress(),
        child: Text(
          label,
          style: GoogleFonts.getFont(
            'Bungee',
            textStyle: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}