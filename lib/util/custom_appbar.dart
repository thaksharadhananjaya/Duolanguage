import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({Key? key})
      : super(
          key: key,
          elevation: 0,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                gradient: LinearGradient(
                    colors: [kPrimaryColor, kSeconderyColor],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
          ),
          actions: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data?.get('point'));
                    return Center(
                      child: Text(
                        "${snapshot.data?.get('point')}",
                        style: GoogleFonts.getFont('Bungee',
                            textStyle: const TextStyle(
                                color: Color.fromARGB(255, 255, 193, 59),
                                fontSize: 26)),
                      ),
                    );
                  }
                  return const SizedBox();
                }),
            Padding(
              padding: const EdgeInsets.only(right: kPadding),
              child: Image.asset(
                'assets/images/point.gif',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: InkWell(
                  child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString().toUpperCase().substring(0,1),
                  style: GoogleFonts.getFont(
                    'Bungee',
                    textStyle: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 24,
                    ),
                  ),
                ),
              )),
            )
          ],
        );
}
