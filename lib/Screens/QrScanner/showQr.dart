import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/providers/userProvider.dart';
import 'package:dorona/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:awesome_dialog/awesome_dialog.dart';

class ShowQr extends StatefulWidget {
  @override
  _ShowQrState createState() => _ShowQrState();
}

class _ShowQrState extends State<ShowQr> {
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
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Center(
              child: QrImage(
                data: userProvider.user.uid,
                version: 4,
                gapless: true,
                embeddedImage: AssetImage(
                  'assets/images/coronamap.png',
                ),
                foregroundColor: blueColor,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Scan this QR to get health status",
            style: subtitleText,
          ),
          SizedBox(height: 20),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000)),
            onPressed: () async {
              
              final scanResult = await scanner.scan();
              FirebaseFirestore.instance
                  .collection('status')
                  .doc(scanResult)
                  .get()
                  .then((value) {
                if (value.exists) {
                  showDialog1(value);
                }
              });
            },
            color: blueColor,
            child: Text(
              "Scan QR Code",
              style: buttonText,
            ),
          )
        ],
      ),
    );
  }

  void showDialog1(DocumentSnapshot doc) {
    AwesomeDialog(
        context: context,
        dialogType: doc.data()['remark'] == "He/she is at low risk"
            ? DialogType.SUCCES
            : doc.data()['remark'] == "He/she is at moderate risk"
                ? DialogType.WARNING
                : DialogType.ERROR,
        title: doc.data()['mobileNumber'],
        desc: doc.data()['remark'],
        btnOk: RaisedButton(
          color: doc.data()['remark'] == "He/she is at low risk"
              ? Color.fromRGBO(0, 202, 113, 1)
              : doc.data()['remark'] == "He/she is at moderate risk"
                  ? Color.fromRGBO(254, 184, 0, 1)
                  : Color.fromRGBO(217, 62, 70, 1),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Okay, Got it",
            style: buttonText,
          ),
        ))
      ..show();
  }
}
