import 'package:duolanguage/config.dart';
import 'package:duolanguage/firebase/authentication.dart';
import 'package:duolanguage/util/custom_button.dart';
import 'package:duolanguage/screens/verifi_email.dart';
import 'package:duolanguage/util/emailfeild.dart';
import 'package:duolanguage/util/google_button.dart';
import 'package:duolanguage/util/passowrdfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pushable_button/pushable_button.dart';

import '../util/gradient_text.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPass = TextEditingController();
  TextEditingController textEditingControllerComPass = TextEditingController();
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
            // buildBottomImages(),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
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
                      controller: textEditingControllerPass, hint: "Password"),
                  Text(
                    "  Comfirm Password",
                    style: GoogleFonts.getFont('Poppins',
                        textStyle: buildLabelStyle()),
                  ),
                  PasswordField(
                      controller: textEditingControllerComPass,
                      hint: "Comfirm Password"),
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
                        buildSignupButton(),
                        const SizedBox(
                          width: 16,
                        ),
                        const GoogleButton()
                      ],
                    ),
                  ),
                  buildSignin()
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

  Row buildSignin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GradientText(
          'Already User?  ',
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
            Navigator.pop(context);
          },
          child: Text(
            "Sign in",
            style: GoogleFonts.getFont(
              'Poppins',
              textStyle: const TextStyle(color: kPrimaryColor, fontSize: 15),
            ),
          ),
        )
      ],
    );
  }

  CustomButton buildSignupButton() {
    return CustomButton(
        onPress: () async {
          final User? user = await Authentication.signUpWithEmail(
              context: context,
              email: "thaksharadhananjaya@gmail.com",
              password: '123456');
          if (!mounted) return;
          if (user != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EmailVerify()));
          }
        },
        label: "SIGN UP",
        width: 160.0);
  }
}
