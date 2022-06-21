import 'package:duolanguage/config.dart';
import 'package:duolanguage/screens/signup.dart';
import 'package:duolanguage/util/emailfeild.dart';
import 'package:duolanguage/util/google_button.dart';
import 'package:duolanguage/util/passowrdfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pushable_button/pushable_button.dart';

import '../firebase/authentication.dart';
import '../util/gradient_text.dart';
import '../util/custom_button.dart';
import 'verifi_email.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPass = TextEditingController();
  bool passVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(
            top: 52, bottom: kPadding, right: kPadding, left: kPadding),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Lottie.asset('assets/jsons/learn.json', width: 300),
            ),
            buildBottomImages(),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "  Email",
                    style: GoogleFonts.getFont('Poppins',
                        textStyle: buildLabelStyle()),
                  ),
                  EmailField(controller: textEditingControllerEmail),
                  Text(
                    "  Password",
                    style: GoogleFonts.getFont('Poppins',
                        textStyle: buildLabelStyle()),
                  ),
                  PasswordField(
                    controller: textEditingControllerPass,
                    hint: "Password",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 35,
                        ),
                        buildSigninButton(),
                        const SizedBox(
                          width: 16,
                        ),
                        const GoogleButton()
                      ],
                    ),
                  ),
                  buildSignup()
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Align buildBottomImages() {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/sign.png',
              width: 170,
              height: 170,
            ),
            Image.asset(
              'assets/images/sign2.png',
              width: 170,
              height: 170,
            ),
          ],
        ));
  }

  Row buildSignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GradientText(
          'New User?  ',
          style: GoogleFonts.getFont(
            'Poppins',
            textStyle: const TextStyle(fontSize: 15),
          ),
          gradient: const LinearGradient(colors: [
            kPrimaryColor,
            kSeconderyColor,
          ]),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Signup()));
          },
          child: Text(
            "Sign up",
            style: GoogleFonts.getFont(
              'Poppins',
              textStyle: const TextStyle(color: kPrimaryColor, fontSize: 15),
            ),
          ),
        )
      ],
    );
  }

  CustomButton buildSigninButton() {
    return CustomButton(
        onPress: () async {
          User? user = await Authentication.signInWithEmailAndPassword(context: context,
              email: "thaksharadghananjaya@gmail.com", password: "1234556");
          if (!mounted) return;
          if (user != null) {
            if (user.emailVerified) {
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EmailVerify()));
            }
          }
        },
        label: "SIGN IN",
        width: 160.0);
  }
}
