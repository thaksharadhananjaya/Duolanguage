import 'package:delayed_display/delayed_display.dart';
import 'package:duolanguage/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../util/gradient_text.dart';

class Vocabulary extends StatefulWidget {
  const Vocabulary({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  /// This has to happen only once6 per app
  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    print(speechEnabled);
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    print(speechEnabled);
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
      context: context,
      builder: (BuildContext context) {
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
                delay: const Duration(milliseconds: 500),
                child: Lottie.asset('assets/jsons/win.json',
                    repeat: false, width: 230, height: 200),
              ),
               Text(
                "Correct !",
                style:  GoogleFonts.getFont('Bungee',
                      textStyle: const TextStyle(
                          color: kPrimaryColor, fontSize: 22)),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/score.gif', width: 40, height: 40),
                   Padding(
                    padding: const EdgeInsets.only(top: 5, left: 6),
                    child: Text(
                      "5",
                      style:  GoogleFonts.getFont('Bungee',
                      textStyle: const TextStyle(
                          color: Color.fromARGB(167, 12, 84, 143), fontSize: 32)),
                    ),
                  ),
                ],
              )
            ],
          )),
        );
      },
    );
  }

  Future<dynamic> showWrongDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SizedBox(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 24,
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 200),
                child: Lottie.asset('assets/jsons/wrong.json',
                    width: 100, height: 100),
              ),
              const SizedBox(
                height: 36,
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  "Try Again !",
                  style: GoogleFonts.getFont('Bungee',
                      textStyle: const TextStyle(
                          color: kSeconderyColor, fontSize: 22)),
                ),
              ),
            ],
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Stack(
            children: [
              bulidWords(),
              buildAnimation(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildActionButtons(),
                    buildNxtButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () async{
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
          const SizedBox(
            width: 50,
          ),
          InkWell(
              onTap: () => speak(text),
              child: Image.asset(
                'assets/images/speaker.png',
                width: 45,
                height: 45,
              )),
        ],
      ),
    );
  }

  Center buildAnimation() {
    return Center(
        child: DelayedDisplay(
      delay: const Duration(milliseconds: 2000),
      child: Lottie.asset('assets/jsons/settings.json'),
    ));
  }

  Padding buildNxtButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 100, left: 100),
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
            'NEXT',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Align bulidWords() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          children: [
            DelayedDisplay(
              delay: const Duration(milliseconds: 2500),
              child: SizedBox(
                width: 200,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: 'English',
                      child: Image.asset(
                        'assets/images/us_flag.jpg',
                        width: 30,
                        height: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    GradientText(
                      'Carpenter',
                      style: Theme.of(context).textTheme.headline4,
                      gradient: const LinearGradient(colors: [
                        kPrimaryColor,
                        kSeconderyColor,
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            DelayedDisplay(
              delay: const Duration(milliseconds: 2800),
              child: SizedBox(
                width: 200,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: 'Spanish',
                      child: Image.asset(
                        'assets/images/spanish_flag.jpg',
                        width: 30,
                        height: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    GradientText(
                      'Carpintero',
                      style: Theme.of(context).textTheme.headline4,
                      gradient: const LinearGradient(colors: [
                        kPrimaryColor,
                        Color.fromARGB(255, 65, 9, 196)
                      ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void speak(String text) {
    TextToSpeech tts = TextToSpeech();
    tts.speak(text);
  }
}
