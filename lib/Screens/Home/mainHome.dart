import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorona/Screens/NearbyYou/peopleNearByYou.dart';
import 'package:dorona/Screens/News/news.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/providers/userProvider.dart';
import 'package:dorona/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(8),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('status')
                  .doc(userProvider.user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                }
                return FadeIn(
                  child: Container(
                    // color: snapshot.data['status'] == 'negative'
                    //     ? greenColor
                    //     : Colors.red,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          snapshot.data['status'] == 'negative'
                              ? greenColor
                              : Colors.red,
                          snapshot.data['status'] == 'negative'
                              ? greenColor.withOpacity(0.8)
                              : Colors.red.withOpacity(0.8)
                        ])),
                    child: ListTile(
                      leading: snapshot.data['status'] == 'negative'
                          ? Image.asset("assets/images/safe.png")
                          : Image.asset("assets/images/unsafe.png"),
                      title: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          snapshot.data['status'] == 'negative'
                              ? "You are safe"
                              : "You are covid positive",
                          style: GoogleFonts.aleo(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PeopleNearByYou(userProvider.user.uid);
                          }));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: snapshot.data['status'] == 'negative'
                                  ? greenColor
                                  : Colors.red,
                              border:
                                  Border.all(color: Colors.white70, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "See others nearby you!",
                                style: buttonText,
                              ),
                              Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                              )
                            ],
                          )),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: width,
            color: Color(0xFFF5F5F7),
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 2),
            child: Text(
              "Preventions",
              style: titleTextStyle,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: SvgPicture.asset(
                      "assets/images/hand_wash.svg",
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: blueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      "Wash hands",
                      style: subtitleText,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: SvgPicture.asset(
                      "assets/images/use_mask.svg",
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: blueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      "Wear mask",
                      style: subtitleText,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: SvgPicture.asset(
                      "assets/images/Clean_Disinfect.svg",
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: blueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      "Clean Disinfect",
                      style: subtitleText,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: blueColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            width: width * 0.9,
            child: Row(
              children: [
                Container(
                  width: 160,
                  height: 160,
                  child: SvgPicture.asset(
                    "assets/images/nurse.svg",
                    height: 160,
                    width: 160,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: width * 0.3,
                      child: Text(
                        "Dial 1075 for Medical Help!",
                        style: simpleTextDrawer,
                      ),
                    ),
                    Container(
                      width: width * 0.3,
                      child: Text(
                        "If any symptoms appear.",
                        style: subtitleTextSmall,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: width,
            color: Color(0xFFF5F5F7),
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 2),
            child: Text(
              "Corona Updates",
              style: titleTextStyle,
            ),
          ),
          News()
        ],
      ),
    );
  }
}
