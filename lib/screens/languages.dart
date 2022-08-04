import 'package:duolanguage/config.dart';
import 'package:duolanguage/screens/home.dart';
import 'package:duolanguage/util/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_to_background/move_to_background.dart';

class Language extends StatelessWidget {
  const Language({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(context, false),
        body: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCard(const Color.fromARGB(255, 200, 201, 241), "es",
                  "Spanish", context),
              buildCard(const Color.fromARGB(255, 200, 201, 241),
                  "fr", "French", context)
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildCard(
      Color color, String language, String text, BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home(language: language,)));

        /* final translator = GoogleTranslator();
            Translation translation = await translator.translate("Duck", to: 'es');
            print(translation.text); */
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 48),
        decoration: BoxDecoration(
            color: color,
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
                  child: Image.asset(
                    "assets/images/${language}_flag.jpg",
                    width: 150,
                    height: 110,
                  )),
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
                      style: GoogleFonts.bungee(
                        textStyle: const TextStyle(
                            color: kSeconderyColor, fontSize: 22),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
