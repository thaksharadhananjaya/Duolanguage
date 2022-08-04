import 'package:duolanguage/config.dart';
import 'package:duolanguage/firebase/authentication.dart';
import 'package:duolanguage/util/custom_button.dart';
import 'package:duolanguage/screens/login/verifi_email.dart';
import 'package:duolanguage/util/emailfeild.dart';
import 'package:duolanguage/util/error.dart';
import 'package:duolanguage/util/google_button.dart';
import 'package:duolanguage/util/passowrdfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../util/gradient_text.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPass = TextEditingController();
  TextEditingController textEditingControllerComPass = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String errorMail = "", errorPassword = "", errorCpassword = "";
  bool passVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(
            top: 32, bottom: kPadding, right: kPadding, left: kPadding),
        child: Stack(
          children: [
            /* Align(
              alignment: Alignment.topCenter,
              child: Lottie.asset('assets/jsons/logo.json', width: 300),
            ), */
             buildBottomImages(),
            Align(
                alignment: Alignment.topCenter,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   
                    Text(
                      "  Email",
                      style: GoogleFonts.getFont('Poppins',
                          textStyle: buildLabelStyle()),
                    ),
                    EmailField(
                      controller: textEditingControllerEmail,
                      validator: (text) => validateEmail(text),
                    ),
                    ErrorMessage(message: errorMail),
                    Text(
                      "  Password",
                      style: GoogleFonts.getFont('Poppins',
                          textStyle: buildLabelStyle()),
                    ),
                    PasswordField(
                      controller: textEditingControllerPass,
                      hint: "Password",
                      validator: (text) => validatePassword(text),
                    ),
                    ErrorMessage(message: errorPassword),
                    Text(
                      "  Comfirm Password",
                      style: GoogleFonts.getFont('Poppins',
                          textStyle: buildLabelStyle()),
                    ),
                    PasswordField(
                      controller: textEditingControllerComPass,
                      hint: "Comfirm Password",
                      validator: (text) => validateComfirmPass(text),
                    ),
                    ErrorMessage(message: errorCpassword),
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
          formKey.currentState!.validate();
          if (errorMail == "" && errorPassword == "" && errorCpassword == "") {
            final User? user = await Authentication.signUpWithEmail(
                context: context,
                email: textEditingControllerEmail.text,
                password: textEditingControllerPass.text);
            if (!mounted) return;
            if (user != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmailVerify(
                            email: user.email.toString(),
                          )));
            }
          }
        },
        label: "SIGN UP",
        width: 160.0);
  }

  void validateEmail(text) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (text.isEmpty) {
      setState(() {
        errorMail = 'Enter your email';
      });
    } else if (!regex.hasMatch(text)) {
      setState(() {
        errorMail = 'Invalid email';
      });
    } else {
      setState(() {
        errorMail = "";
      });
    }
  }

  void validatePassword(text) {
    if (text.isEmpty) {
      setState(() {
        errorPassword = 'Enter your password';
      });
    } else if (text.length < 6) {
      setState(() {
        errorPassword = 'Password must be at least 6 characters';
      });
    } else {
      setState(() {
        errorPassword = "";
      });
    }
  }

  void validateComfirmPass(text) {
    if (text != textEditingControllerPass.text) {
      setState(() {
        errorCpassword = 'Password does not match';
      });
    } else {
      setState(() {
        errorCpassword = "";
      });
    }
  }
}
