import 'package:duolanguage/config.dart';
import 'package:duolanguage/screens/vocabulary/category.dart';
import 'package:duolanguage/screens/quiz.dart';
import 'package:duolanguage/util/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Home extends StatelessWidget {
  final String language;
  const Home({Key? key, required this.language}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, true),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCard("Vocabulary", "voc.json", () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Category(language: language,)));
              }),
              //const SizedBox(height: 72,),
              buildCard("Quiz Game", "quiz.json", () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  Quiz(language: language,)));
              }),
            ]),
      ),
    );
  }

  InkWell buildCard(String text, String path, Function onPress) {
    return InkWell(
      onTap: () => onPress(),
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 28, top: 2),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 200, 201, 241),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.4,
                  offset: Offset(0.0, 4))
            ]),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 64),
                  child: Lottie.asset("assets/jsons/$path"),
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0))),
                  child: Text(text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Bungee',
                        textStyle:
                            const TextStyle(color: kPrimaryColor, fontSize: 22),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
