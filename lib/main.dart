import 'package:duolanguage/screens/quiz.dart';
import 'package:flutter/material.dart';

import 'screens/vocabulary.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duolanguage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            headline4: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
          )),
      home: const Quiz(),
    );
  }
}
