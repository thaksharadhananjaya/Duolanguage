 import 'package:flutter/material.dart';

void showCustomSnakBar(String content, BuildContext context, {Color color = Colors.redAccent}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          content,
          style:  TextStyle(color: color, letterSpacing: 0.5),
        ),
      ),
    );
  }