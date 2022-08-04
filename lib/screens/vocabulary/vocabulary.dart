import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:duolanguage/config.dart';
import 'package:duolanguage/util/custom_appbar.dart';
import 'package:duolanguage/util/custom_button.dart';
import 'package:duolanguage/util/wrong_dailog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:translator/translator.dart';

import '../../util/custom_snakbar.dart';
import '../../util/gradient_text.dart';
import '../../util/win_dialog.dart';

class Vocabulary extends StatefulWidget {
  final String docID;
  final String language;
  const Vocabulary({Key? key, required this.docID, required this.language}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VocabularyState createState() => _VocabularyState();
}

class _VocabularyState extends State<Vocabulary> {
  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  bool isListining = false;
  String recognizedWords = "";
  String text = '';

  int pageIndex = 0;
  int maxPage = 0;
  final translator = GoogleTranslator();
  @override
  void initState() {
    super.initState();
    initSpeech();
  }

 

  Future<dynamic> showWinDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => const WinDialog(
              isPoint: false,
            ));
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
      appBar: CustomAppBar(context, true),
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

                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          buildTranslate(data['word']),
                          buildWord(data['word'].toUpperCase()),
                        ],
                      ),
                    ),
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

  Row buildWord(String word) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: "English - US",
          child: Image.asset(
            'assets/images/us_flag.png',
            width: 30,
            height: 25,
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        Text(
          word,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                color: kPrimaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
                onTap: text != ''
                    ? () async {
                        if(widget.language=="en"){
                          if (await Permission.microphone.request().isGranted) {
                          if (await Permission.bluetooth.request().isGranted) {
                            !isListining ? startListening() : stopListening();
                          }
                        }
                        }else{
                          showCustomSnakBar('Sorry.. \nSpeach recognize is English language only !', context);
                        }
                        //showWinDialog();
                        //showWrongDialog();
                      }
                    : null,
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
                onTap: () => text != '' ? speak(text) : null,
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
      child: Lottie.network(
        link,
        height: 350,
      ),
    ));
  }

  Padding buildNxtButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 100, left: 100),
      child: DelayedDisplay(
        delay: const Duration(milliseconds: 800),
        child: CustomButton(
          label: pageIndex < maxPage - 1 ? 'NEXT' : 'HOME',
          onPress: () {
            if (pageIndex < maxPage - 1) {
              setState(() {
                pageIndex++;
              });
            } else {
              Navigator.pop(context);
            }
          },
          width: double.maxFinite,
        ),
      ),
    );
  }

  FutureBuilder buildTranslate(String text) {
    return FutureBuilder(
        future: translate(text),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            this.text = snapshot.data;

            return DelayedDisplay(
              delay: const Duration(milliseconds: 500),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/${widget.language}_flag.jpg',
                    width: 30,
                    height: 25,
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  GradientText(
                    snapshot.data,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
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
          return const SizedBox();
        });
  }

  Future<void> speak(String text) async {
    TextToSpeech tts = TextToSpeech();
    print(await tts.getLanguages());
    tts.speak(text);
  }

  Future<String> translate(String text) async {
    String transWord = "";
    try {
      final Translation translation =
          await translator.translate(text, to: widget.language);
      transWord = translation.text;
    } catch (e) {
      print(e);
    }
    return transWord;
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
}
