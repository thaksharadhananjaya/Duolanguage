import 'package:duolanguage/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailField extends StatefulWidget {
  TextEditingController controller = TextEditingController();

  EmailField({Key? key, required this.controller})
      : super(key: key);

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 8, bottom: 48),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: buildTextContDecoration(),
      child: TextFormField(
        controller: widget.controller,
        style: GoogleFonts.getFont(
          'Poppins',
        ),
        maxLength: 150,
        decoration: InputDecoration(
            hintText: "Email",
            counterText: '',
            prefixIcon: const Icon(
              Icons.email,
              color: kPrimaryColor,
            ),
            hintStyle: GoogleFonts.getFont(
              'Poppins',
              textStyle: const TextStyle(color: Colors.grey),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none),
      ),
    );
  }
}


