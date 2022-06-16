import 'package:duolanguage/config.dart';
import 'package:duolanguage/screens/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List category = [
    [
      "Animals",
      "https://dl.dropboxusercontent.com/s/kfsv02ibt2l1n68/elephant.png"
    ],
    ["Vehicles", "https://dl.dropbox.com/s/rprnq5bo83kq05k/cruise-control.png"],
    ["Jobs", "https://dl.dropbox.com/s/tg40p4kjfqkofyg/job-search.png"]
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 42, top: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("SELECT  ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Bungee',
                        textStyle: const TextStyle(
                            color: kSeconderyColor, fontSize: 28),
                      )),
                  Text("CATEGORY",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Bungee',
                        textStyle:
                            const TextStyle(color: kPrimaryColor, fontSize: 28),
                      )),
                ],
              ),
            ),
            buildCategoryList(),
          ],
        ),
      )),
    );
  }

  SizedBox buildCategoryList() {
    double height = MediaQuery.of(context).size.height * 0.785;
    return SizedBox(
      height: height,
      child: ListView.builder(
          itemCount: category.length,
          itemBuilder: (context, index) {
            return buildCard(index, category[index][0], category[index][1]);
          }),
    );
  }

  InkWell buildCard(int index, String text, String link) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Vocabulary(category: text)));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 28, top: 2),
        decoration: BoxDecoration(
            color: index % 2 == 0
                ? const Color.fromARGB(255, 200, 201, 241)
                : Color.fromARGB(255, 236, 200, 241),
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
                      style: GoogleFonts.getFont(
                        'Bungee',
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
