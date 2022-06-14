import 'package:duolanguage/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:delayed_display/delayed_display.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int selectedIndex = -1;
  List<String> link = [
    'https://assets9.lottiefiles.com/private_files/lf30_oiaetlzu.json',
    'https://assets5.lottiefiles.com/packages/lf20_flosnlcw.json',
    'https://assets10.lottiefiles.com/packages/lf20_itqodaed.json',
    'https://assets10.lottiefiles.com/private_files/lf30_Q1Ptzp.json'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('CHOSE A  ',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.getFont(
                                'Bungee',
                                textStyle: const TextStyle(
                                    color: kSeconderyColor, fontSize: 24),
                              )),
                          Text("'Duck'",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.getFont(
                                'Bungee',
                                textStyle: const TextStyle(
                                    color: kPrimaryColor, fontSize: 24),
                              )),
                        ],
                      ),
                    ),
                    buildAnsGrid(),
                  ]),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buildCheckButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildAnsGrid() {
    return Padding(
      padding: const EdgeInsets.only(top: 42),
      child: SizedBox(
        height: 400,
        width: double.maxFinite,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 24, mainAxisSpacing: 36),
          itemCount: 4,
          itemBuilder: (context, index) {
            return buildAnsCard(index, true);
          },
        ),
      ),
    );
  }

  GestureDetector buildAnsCard(int index, bool isAns) {
    double width = ((MediaQuery.of(context).size.width) - 48) / 2;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: width,
        height: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: selectedIndex != index ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(255, 207, 206, 206),
                  blurRadius: 0.4,
                  offset: Offset(0.0, 4))
            ]),
        child: Lottie.network(
          link[index],
        ),
      ),
    );
  }

  Padding buildCheckButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, right: 100, left: 100),
      child: DelayedDisplay(
        delay: const Duration(milliseconds: 2500),
        child: PushableButton(
          height: 50,
          elevation: 5,
          hslColor: HSLColor.fromColor(kSeconderyColor),
          shadow: BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
          onPressed: () {},
          child: const Text(
            'CHECK',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}