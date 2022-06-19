import 'package:duolanguage/config.dart';
import 'package:duolanguage/util/google_button.dart';
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
  TextEditingController textEditingControllerUser = TextEditingController();
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
                  buildEmailTextFeild(),
                  Text(
                    "  Password",
                    style: GoogleFonts.getFont('Poppins',
                        textStyle: buildLabelStyle()),
                  ),
                  buildPswdTextFeild(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 36,
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
          onTap: () {},
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

  SizedBox buildSigninButton() {
    return SizedBox(
      width: 160,
      child: PushableButton(
        height: 48,
        elevation: 5,
        hslColor: HSLColor.fromColor(kSeconderyColor),
        shadow: BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
        onPressed: () {},
        child: Text(
          'SIGN IN',
          style: GoogleFonts.getFont(
            'Bungee',
            textStyle: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }

  Container buildEmailTextFeild() {
    return Container(
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 8, bottom: 48),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: buildTextContDecoration(),
      child: TextFormField(
        controller: textEditingControllerUser,
        style: GoogleFonts.getFont(
          'Poppins',
        ),
        maxLength: 150,
        decoration: InputDecoration(
            hintText: "Email",
            counterText: '',
            prefixIcon: const Icon(
              Icons.email,
              color: kPrimaryColor,
            ),
            hintStyle: GoogleFonts.getFont(
              'Poppins',
              textStyle: const TextStyle(color: Colors.grey),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none),
      ),
    );
  }

  Container buildPswdTextFeild() {
    return Container(
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: buildTextContDecoration(),
      child: TextFormField(
        obscureText: passVisible,
        controller: textEditingControllerPass,
        style: GoogleFonts.getFont(
          'Poppins',
        ),
        maxLength: 8,
        decoration: InputDecoration(
            hintText: "Password",
            counterText: '',
            prefixIcon: const Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            hintStyle: GoogleFonts.getFont(
              'Poppins',
              textStyle: const TextStyle(color: Colors.grey),
            ),
            suffixIcon: InkWell(
                onTap: (() => setState(() {
                      passVisible ? passVisible = false : passVisible = true;
                    })),
                child: passVisible
                    ? const Icon(
                        Icons.visibility_off,
                        color: kPrimaryColor,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: kPrimaryColor,
                      )),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none),
      ),
    );
  }

//*****  Decorations *****
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
}
