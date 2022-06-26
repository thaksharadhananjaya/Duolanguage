import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duolanguage/config.dart';
import 'package:duolanguage/model/quiz_data.dart';
import 'package:duolanguage/util/custom_appbar.dart';
import 'package:duolanguage/util/custom_snakbar.dart';
import 'package:duolanguage/util/win_dialog.dart';
import 'package:duolanguage/util/wrong_dailog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:delayed_display/delayed_display.dart';

import '../util/gradient_text.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int selectedIndex = 0;
  int pageIndex = 0;
  int maxPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, true),
      backgroundColor: kBackgroundColor,
      body: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('quiz').get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot data = snapshot.data!.docs[pageIndex];
                maxPage = snapshot.data!.docs.length;
                return builBody(data);
              }
              return const Center(
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator()));
            }),
      ),
    );
  }

  Padding builBody(DocumentSnapshot<Object?> data) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              buildTopic(data["word"]),
              buildAnsGrid(data["answer"]),
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildCheckButton(data["answer"]),
          )
        ],
      ),
    );
  }

  DelayedDisplay buildTopic(String word) {
    return DelayedDisplay(
      delay: const Duration(microseconds: 100),
      child: Padding(
        padding: const EdgeInsets.only(top: 36, bottom: 42),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('CHOSE A  ',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Bungee',
                  textStyle:
                      const TextStyle(color: kSeconderyColor, fontSize: 24),
                )),
            Text("'$word'",
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Bungee',
                  textStyle:
                      const TextStyle(color: kPrimaryColor, fontSize: 24),
                )),
          ],
        ),
      ),
    );
  }

  SizedBox buildAnsGrid(var data) {
    return SizedBox(
      height: 400,
      width: double.maxFinite,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 24, mainAxisSpacing: 36),
        itemCount: 4,
        itemBuilder: (context, index) {
          var answer = data["${index + 1}"];
          return buildAnsCard(index + 1, answer["link"], answer["correct"]);
        },
      ),
    );
  }

  DelayedDisplay buildAnsCard(int index, String link, bool isAns) {
    double width = ((MediaQuery.of(context).size.width) - 48) / 2;
    return DelayedDisplay(
      delay: Duration(microseconds: 100 + 50 * index),
      child: GestureDetector(
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
            link,
          ),
        ),
      ),
    );
  }

  Padding buildCheckButton(var data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, right: 100, left: 100),
      child: DelayedDisplay(
        delay: const Duration(milliseconds: 500),
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
          onPressed: () => checkAnswer(data),
          child: Text('CHECK',
              style: GoogleFonts.getFont(
                'Bungee',
                textStyle: const TextStyle(color: Colors.white, fontSize: 22),
              )),
        ),
      ),
    );
  }

  AlertDialog showCompleteDailog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SizedBox(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          DelayedDisplay(
            delay: const Duration(milliseconds: 50),
            child: Lottie.asset('assets/jsons/complete.json',
                repeat: false, width: 230, height: 200),
          ),
          DelayedDisplay(
            delay: const Duration(milliseconds: 300),
            child: GradientText(
              "Congratulations !",
              style: GoogleFonts.poppins(
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              gradient: const LinearGradient(colors: [
                kPrimaryColor,
                kSeconderyColor,
              ]),
            ),
          ),
          DelayedDisplay(
            delay: const Duration(milliseconds: 400),
            child: Text(
              "Complete All Quizes",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(color: Colors.green, fontSize: 16)),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      )),
    );
  }

  Future<void> checkAnswer(data) async {
    if (selectedIndex == 0) {
      showCustomSnakBar("Please select your answer !", context);
    } else if (data[selectedIndex.toString()]["correct"]) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      FirebaseFirestore.instance
          .collection("user")
          .doc(user?.uid)
          .update({'point': FieldValue.increment(5)});
      if (pageIndex < maxPage - 1) {
        await showDialog(
            context: context,
            builder: (BuildContext context) => const WinDialog(
                  isPoint: true,
                ));
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            selectedIndex = -1;
            pageIndex++;
          });
        });
      } else {
        await showDialog(
            context: context,
            builder: (BuildContext context) => showCompleteDailog());
        if (!mounted) return;
        Navigator.pop(context);
      }
    } else {
      await showDialog(
          context: context,
          builder: (BuildContext context) => const WrongDialog());
      setState(() {
        selectedIndex = -1;
      });
    }
  }
}
