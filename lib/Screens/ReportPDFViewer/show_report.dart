import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/providers/userProvider.dart';
import 'package:dorona/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ShowReport extends StatefulWidget {
  @override
  _ShowReportState createState() => _ShowReportState();
}

class _ShowReportState extends State<ShowReport> {
  int currentPage, totalPage;
  bool isPdfLoaded = false;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: blueColor),
        actions: [],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            userProvider.user.phoneNumber,
            style: subtitleText,
          ),
          SizedBox(height: 25),
          FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(userProvider.user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container(
                  height: MediaQuery.of(context).size.height - 170,
                  child: snapshot.data.data()['reportUrl'] == null
                      ? Center(
                          child: Column(
                          children: [
                            Image.asset("assets/images/google-docs.png"),
                            SizedBox(height:10),
                            Text(
                              'No Report Available',
                              style: GoogleFonts.aleo(),
                            ),
                          ],
                        ))
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: PDF(
                            swipeHorizontal: true,
                            onViewCreated: (controller) async {},
                            onPageChanged: (page, total) {
                              print(page);
                              print(total);
                              currentPage = page;
                              totalPage = total;
                              setState(() {
                                isPdfLoaded = true;
                              });
                            },
                          ).cachedFromUrl(snapshot.data.data()['reportUrl']),
                        )),
                );
              }),
          isPdfLoaded
              ? FadeIn(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "${currentPage + 1}/$totalPage",
                      style: GoogleFonts.aleo(color: Colors.white),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
