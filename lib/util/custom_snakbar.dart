 import 'package:flutter/material.dart';

void showCustomSnakBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          content,
          style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
        ),
      ),
    );
  }