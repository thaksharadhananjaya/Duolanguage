import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 2, bottom: 32),
      child: Text(
        message,
        style: GoogleFonts.getFont('Poppins',
            textStyle: const TextStyle(color: Colors.red, fontSize: 12)),
      ),
    );
  }
}
