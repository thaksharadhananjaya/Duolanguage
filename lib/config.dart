import 'package:flutter/material.dart';

const double kPadding = 16;
const Color kBackgroundColor = Color.fromARGB(255, 245, 238, 248);
const Color kPrimaryColor = Colors.blue;
const Color kSeconderyColor = Colors.purple;

BoxDecoration buildTextContDecoration() {
  return BoxDecoration(
      color: const Color.fromARGB(255, 220, 217, 248),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
            color: Color.fromARGB(255, 174, 135, 238),
            blurRadius: 0.4,
            offset: Offset(0.0, 4))
      ]);
}

TextStyle buildLabelStyle() {
  return const TextStyle(
      color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.w500);
}
