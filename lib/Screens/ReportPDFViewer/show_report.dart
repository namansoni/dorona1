import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/providers/userProvider.dart';
import 'package:dorona/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowReport extends StatefulWidget {
  @override
  _ShowReportState createState() => _ShowReportState();
}

class _ShowReportState extends State<ShowReport> {
  Future<PDFDocument> loadPDF(UserProvider userProvider) async {
    try {
      print(userProvider.user.uid);
      var doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userProvider.user.uid)
          .get();
      print('data collected');
      var url = doc.data()['reportUrl'];
      var document = await PDFDocument.fromURL(url);
      print('page coun -${document.count}');
      return document;
    } on Exception catch (e) {
      print('error while Loading ${e}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: blueColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            userProvider.user.phoneNumber,
            style: subtitleText,
          ),
          SizedBox(height: 25),
          FutureBuilder<PDFDocument>(
              future: loadPDF(userProvider),
              builder: (context, snapshot) {
                if (!snapshot.hasData && snapshot.hasError)
                  return Center(child: CircularProgressIndicator());
                return Container(
                  height: MediaQuery.of(context).size.height - 170,
                  child: snapshot.data == null
                      ? Center(child: Text('No Report Available'))
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: PDFViewer(
                            document: snapshot.data,
                            zoomSteps: 1,
                            scrollDirection: Axis.vertical,
                            lazyLoad: false,
                            showPicker: false,
                            indicatorBackground: blueColor.withOpacity(0.7),
                            minScale: 1.0,
                            maxScale: 5.0,
                          ),
                        )),
                );
              }),
        ],
      ),
    );
  }
}
