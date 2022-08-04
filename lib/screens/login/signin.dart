import 'package:duolanguage/config.dart';
import 'package:duolanguage/screens/login/signup.dart';
import 'package:duolanguage/util/custom_snakbar.dart';
import 'package:duolanguage/util/emailfeild.dart';
import 'package:duolanguage/util/error.dart';
import 'package:duolanguage/util/google_button.dart';
import 'package:duolanguage/util/passowrdfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:move_to_background/move_to_background.dart';

import '../../firebase/authentication.dart';
import '../../util/gradient_text.dart';
import '../../util/custom_button.dart';
import '../languages.dart';
import 'verifi_email.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController textEditingControllerEmail =
      TextEditingController();
  final TextEditingController textEditingControllerPass =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String errorMail = "", errorPassword = "";
  bool passVisible = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        {
          MoveToBackground.moveTaskToBack();
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(
              top: 64, bottom: kPadding, right: kPadding, left: kPadding),
          child: Stack(
            children: [
              
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
                        validator: (text) {
                          validateEmail(text);
                        },
                      ),
                      ErrorMessage(
                        message: errorMail,
                      ),
                      Text(
                        "  Password",
                        style: GoogleFonts.getFont('Poppins',
                            textStyle: buildLabelStyle()),
                      ),
                      PasswordField(
                        controller: textEditingControllerPass,
                        hint: "Password",
                        validator: (text) {
                          if (text.isEmpty) {
                            setState(() {
                              errorPassword = 'Enter your password';
                            });
                          } else {
                            setState(() {
                              errorPassword = "";
                            });
                          }
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ErrorMessage(
                            message: errorPassword,
                          ),
                          InkWell(
                            onTap: () {
                              if (textEditingControllerEmail.text.isNotEmpty) {
                                Authentication.sendPasswordRestLink(
                                    context: context,
                                    email: textEditingControllerEmail.text);
                              } else {
                                showCustomSnakBar(
                                    "Please enter your email.", context);
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 12),
                              child: SizedBox(
                                height: 20,
                                child: Text(
                                  "Reset Password",
                                  style: GoogleFonts.getFont('Poppins',
                                      textStyle: const TextStyle(
                                          color: Colors.black45, fontSize: 11)),
                                ),
                              ),
                            ),
                          )
                        ],
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
              ),
            ],
          ),
        )),
      ),
    );
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
          formKey.currentState!.validate();
          if (errorMail == "" && errorPassword == "") {
            User? user = await Authentication.signInWithEmailAndPassword(
                context: context,
                email: textEditingControllerEmail.text,
                password: textEditingControllerPass.text);
            if (!mounted) return;
            if (user != null) {
              if (user.emailVerified) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Language()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmailVerify(
                              email: user.email.toString(),
                            )));
              }
            }
          }
        },
        label: "SIGN IN",
        width: 160.0);
  }
}
