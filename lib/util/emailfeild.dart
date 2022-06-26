import 'package:duolanguage/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<dynamic>  validator;

 const EmailField({Key? key, required this.controller, required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: buildTextContDecoration(),
      child: TextFormField(
        controller: controller,
        validator: (text){
          validator(text);
        },
        style: GoogleFonts.getFont(
          'Poppins',
        ),
        keyboardType: TextInputType.emailAddress,
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
