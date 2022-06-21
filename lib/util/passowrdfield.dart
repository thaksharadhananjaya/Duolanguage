import 'package:duolanguage/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordField extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  final String hint;
  PasswordField({Key? key, required this.controller, required this.hint})
      : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool passVisible = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 8, bottom: 48),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: buildTextContDecoration(),
      child: TextFormField(
        obscureText: passVisible,
        controller: widget.controller,
        style: GoogleFonts.getFont(
          'Poppins',
        ),
        maxLength: 8,
        decoration: InputDecoration(
            hintText: widget.hint,
            counterText: '',
            prefixIcon: const Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            hintStyle: GoogleFonts.getFont(
              'Poppins',
              textStyle: const TextStyle(color: Colors.grey),
            ),
            suffixIcon: InkWell(
                onTap: (() => setState(() {
                      passVisible ? passVisible = false : passVisible = true;
                    })),
                child: passVisible
                    ? const Icon(
                        Icons.visibility_off,
                        color: kPrimaryColor,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: kPrimaryColor,
                      )),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none),
      ),
    );
  }
}


