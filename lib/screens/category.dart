import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duolanguage/config.dart';
import 'package:duolanguage/screens/vocabulary.dart';
import 'package:duolanguage/util/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(context, true),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          children: [
            buildTopic(),
            FutureBuilder<QuerySnapshot>(
                future:
                    FirebaseFirestore.instance.collection('vocabulary').get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return buildCategoryList(snapshot);
                  }
                  return const Center(
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator()));
                }),
          ],
        ),
      ),
    );
  }

  Padding buildTopic() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42, top: kPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("SELECT  ",
              textAlign: TextAlign.center,
              style: GoogleFonts.bungee(
                textStyle:
                    const TextStyle(color: kSeconderyColor, fontSize: 28),
              )),
          Text("CATEGORY",
              textAlign: TextAlign.center,
              style: GoogleFonts.bungee(
                textStyle: const TextStyle(color: kPrimaryColor, fontSize: 28),
              )),
        ],
      ),
    );
  }

  SizedBox buildCategoryList(AsyncSnapshot snapshot) {
    double height = MediaQuery.of(context).size.height * 0.7;
    return SizedBox(
      height: height,
      child: ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot data = snapshot.data!.docs[index];

            return buildCard(index, data['category'], data['link'], data.id);
          }),
    );
  }

  InkWell buildCard(int index, String text, String link, String docID) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Vocabulary(docID: docID)));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 28, top: 2),
        decoration: BoxDecoration(
            color: index % 2 == 0
                ? const Color.fromARGB(255, 200, 201, 241)
                : const Color.fromARGB(255, 236, 200, 241),
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
                child: Image.network(link, width: 150, height: 120),
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
                      style: GoogleFonts.bungee(
                        textStyle: TextStyle(
                            color: index % 2 == 0
                                ? kPrimaryColor
                                : kSeconderyColor,
                            fontSize: 22),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
