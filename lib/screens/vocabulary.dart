import 'package:delayed_display/delayed_display.dart';
import 'package:duolanguage/config.dart';
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
  final String category;
  const Vocabulary({Key? key, required this.category}) : super(key: key);

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Stack(
            children: [bulidWords(), buildAnimation(), buildButons()],
          ),
        ),
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

  Center buildAnimation() {
    return Center(
        child: DelayedDisplay(
      delay: const Duration(milliseconds: 500),
      child: Lottie.asset('assets/jsons/settings.json'),
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
              delay: const Duration(milliseconds: 900),
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
              delay: const Duration(milliseconds: 1100),
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
