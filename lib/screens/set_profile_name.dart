import 'package:duolanguage/config.dart';
import 'package:duolanguage/firebase/authentication.dart';
import 'package:duolanguage/screens/languages.dart';


import 'package:flutter/material.dart';

import '../util/custom_button.dart';

class SetName extends StatelessWidget {
  SetName({Key? key}) : super(key: key);
  final TextEditingController textEditingControllerName =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textEditingControllerName,
            ),
            buildNextButton(context)
          ],
        ),
      )),
    );
  }

  CustomButton buildNextButton(BuildContext context) {
    return CustomButton(
        onPress: () async {
          bool result = await Authentication.updateUserName(textEditingControllerName.text);
          //if (!mounted) return;
          if (result) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Language()));
          }
        },
        label: "NEXT",
        width: 160.0);
  }
}
