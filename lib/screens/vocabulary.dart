import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:duolanguage/config.dart';
import 'package:duolanguage/util/custom_appbar.dart';
import 'package:duolanguage/util/wrong_dailog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../util/gradient_text.dart';
import '../util/win_dialog.dart';

class Vocabulary extends StatefulWidget {
  final String docID;
  const Vocabulary({Key? key, required this.docID}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VocabularyState createState() => _VocabularyState();
}

class _VocabularyState extends State<Vocabulary> {
  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  bool isListining = false;
  String recognizedWords = "";
  String text = 'Carpenter';

  int pageIndex = 0;
  int maxPage = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  /// This has to happen only once6 per app
  void initSpeech() async {
    speechEnabled = await speechToText.initialize();

    setState(() {});
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    isListining = true;
    await speechToText.listen(onResult: onSpeechResult);

    //setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    print(recognizedWords);
    recognizedWords = result.recognizedWords.toString();
  }

  void stopListening() async {
    await speechToText.stop();
    isListining = false;

    if (recognizedWords == text.toLowerCase()) {
      showWinDialog();
    } else {
      showWrongDialog();
    }
    recognizedWords = "";
    print("stop");
  }

  Future<dynamic> showWinDialog() {
    return showDialog(
        context: context, builder: (BuildContext context) => const WinDialog());
  }

  Future<dynamic> showWrongDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => const WrongDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('vocabulary')
                .doc(widget.docID)
                .collection("words")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot data = snapshot.data!.docs[pageIndex];
                maxPage = snapshot.data!.docs.length;
                text = data['word'];
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        text.toUpperCase(),
                        style: GoogleFonts.getFont(
                          'Bungee',
                          textStyle: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    bulidWords(data['translate']),
                    buildAnimation(data['link']),
                    buildButons()
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Align buildButons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildActionButtons(),
          buildNxtButton(),
        ],
      ),
    );
  }

  Padding buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DelayedDisplay(
            delay: const Duration(milliseconds: 1050),
            child: InkWell(
                onTap: () async {
                  if (await Permission.microphone.request().isGranted) {
                    if (await Permission.bluetooth.request().isGranted) {
                      !isListining ? startListening() : stopListening();
                    }
                  }
                  //showWinDialog();
                  //showWrongDialog();
                },
                child: Image.asset(
                  'assets/images/mic.png',
                  width: 45,
                  height: 45,
                )),
          ),
          const SizedBox(
            width: 50,
          ),
          DelayedDisplay(
            delay: const Duration(milliseconds: 1100),
            child: InkWell(
                onTap: () => speak(text),
                child: Image.asset(
                  'assets/images/speaker.png',
                  width: 45,
                  height: 45,
                )),
          ),
        ],
      ),
    );
  }

  Center buildAnimation(String link) {
    return Center(
        child: DelayedDisplay(
      delay: const Duration(milliseconds: 500),
      child: Lottie.network(link, height: 350),
    ));
  }

  Padding buildNxtButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 100, left: 100),
      child: DelayedDisplay(
        delay: const Duration(milliseconds: 800),
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
          onPressed: () {
            if (pageIndex < maxPage - 1) {
              setState(() {
                pageIndex++;
              });
            }
          },
          child: Text('NEXT',
              style: GoogleFonts.getFont(
                'Bungee',
                textStyle: const TextStyle(color: Colors.white, fontSize: 22),
              )),
        ),
      ),
    );
  }

  Align bulidWords(List words) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 56),
        child: SizedBox(
          width: 200,
          height: 400,
          child: ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                return buildWord(words[index]['lang'], words[index]['word'],
                    900 + index * 10);
              }),
        ),
      ),
    );
  }

  DelayedDisplay buildWord(String lang, String word, int time) {
    return DelayedDisplay(
      delay: Duration(milliseconds: time),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: lang,
            child: Image.asset(
              'icons/flags/png/${lang.substring(0, 2).toLowerCase()}.png',
              package: 'country_icons',
              width: 30,
              height: 25,
              errorBuilder: (context, exception, stackTrace) {
                return Image.asset(
                  "assets/images/rect.jpg",
                  width: 30,
                  height: 25,
                );
              },
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          GradientText(
            word,
            style: GoogleFonts.getFont(
              'Poppins',
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            gradient: const LinearGradient(colors: [
              kPrimaryColor,
              kSeconderyColor,
            ]),
          ),
        ],
      ),
    );
  }

  void speak(String text) {
    TextToSpeech tts = TextToSpeech();
    tts.speak(text);
  }
}
