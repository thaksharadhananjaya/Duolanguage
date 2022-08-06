
import 'package:duolanguage/screens/languages.dart';

import 'package:duolanguage/screens/login/signin.dart';
import 'package:duolanguage/screens/splash.dart';
import 'package:duolanguage/screens/login/verifi_email.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Duolanguage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            headline4: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
          )),
      home:  FutureBuilder(
          future: Future.delayed(const Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final FirebaseAuth auth = FirebaseAuth.instance;
              final User? user = auth.currentUser;
              if (user != null) {
                if(user.emailVerified){
                  return const Language() ;
                }else{
                  return  EmailVerify(email: user.email.toString(),);
                }
              }else{
                return const Signin();
              }
            }
            return Spalsh();
          }) ,
    );
  }
}
