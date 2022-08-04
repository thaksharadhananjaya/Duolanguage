import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:duolanguage/config.dart';
import 'package:duolanguage/screens/login/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../firebase/authentication.dart';
import '../util/custom_button.dart';
import '../util/gradient_text.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  String name = "  ${FirebaseAuth.instance.currentUser!.displayName.toString()}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // appBar: AppBar(elevation: 0,backgroundColor: kBackgroundColor),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Stack(
            children: [
              buildTopWelcomeArt(),
              buildEarn(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: buildSignoutButton(context)),
            ],
          ),
        ),
      ),
    );
  }

  Center buildEarn() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DelayedDisplay(
            delay: const Duration(milliseconds: 1600),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 24,
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: Text(
                            "${snapshot.data?.get('point')}",
                            style: GoogleFonts.getFont('Bungee',
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 193, 59),
                                    fontSize: 54)),
                          ),
                        );
                      }
                      return const SizedBox();
                    }),
                Image.asset(
                  'assets/images/point.gif',
                  width: 120,
                  height: 120,
                ),
              ],
            ),
          ),
          DelayedDisplay(
              delay: const Duration(milliseconds: 400),
              child: Lottie.asset('assets/jsons/earn.json', repeat: false)),
          DelayedDisplay(
        delay: const Duration(milliseconds: 1650),
            child: GradientText(
              "Learn & Earn More Points",
              style: GoogleFonts.poppins(
                textStyle:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              gradient: const LinearGradient(colors: [
                kSeconderyColor,
                kPrimaryColor,
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildSignoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: DelayedDisplay(
          delay: const Duration(milliseconds: 500),
        child: CustomButton(
            onPress: () async {
              await Authentication.signOut(context: context);
      
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const Signin()));
            },
            label: "Sign Out",
            width: 180.0),
      ),
    );
  }

  Align buildTopWelcomeArt() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: kPadding, top: kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DelayedDisplay(
              delay: const Duration(milliseconds: 100),
              child: Text(
                "Hi 👋,",
                style: GoogleFonts.bungee(
                  textStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kSeconderyColor),
                ),
              ),
            ),
            DelayedDisplay(
              delay: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 4),
                child: SizedBox(
                  width: double.infinity,
                  child: GradientText(
                    name,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    gradient: const LinearGradient(colors: [
                      kPrimaryColor,
                      kSeconderyColor,
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
