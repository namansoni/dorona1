import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dorona/colors1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/src/widgets/image.dart' as imageView;

class XRayTestHome extends StatefulWidget {
  @override
  _XRayTestHomeState createState() => _XRayTestHomeState();
}

class _XRayTestHomeState extends State<XRayTestHome> {
  String res;
  final _picker = ImagePicker();
  String pickedImagePath;
  bool isModelLoaded = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: blueColor),
        title: Text(
          "Test using X-Ray Image",
          style: GoogleFonts.aleo(color: blueColor),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: pickedImagePath == null ? Colors.grey[400] : blueColor,
        onPressed: pickedImagePath == null
            ? null
            : isLoading
                ? null
                : () {
                    startTest();
                  },
        label: isLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                "Start Test",
                style: GoogleFonts.aleo(
                  color: Colors.white,
                ),
              ),
      ),
      body: !isModelLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AbsorbPointer(
              absorbing: isLoading,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        pickedImagePath == null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: blueColor.withOpacity(0.3),
                                    width: 3,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 300,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: RaisedButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      chooseImage();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          color: blueColor,
                                        ),
                                        Text(
                                          "Choose X-Ray Image",
                                          style: GoogleFonts.aleo(
                                            color: blueColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: blueColor.withOpacity(0.2),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.clear_rounded,
                                          color: blueColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            pickedImagePath = null;
                                          });
                                        }),
                                    imageView.Image.file(
                                      new File(
                                        pickedImagePath,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 300,
                                      fit: BoxFit.fill,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void loadModel() async {
    res = await Tflite.loadModel(
        model: "assets/chestXRayModel/model.tflite",
        labels: "assets/chestXRayModel/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
    print("model loaded: $res");
    if (res == "success") {
      setState(() {
        isModelLoaded = true;
      });
    }
  }

  Uint8List imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  void chooseImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      pickedImagePath = pickedFile.path;
    });
    Uint8List bytes = await pickedFile.readAsBytes();
  }

  void startTest() async {
    // var recognitions;
    // try {
    //   recognitions = await Tflite.runModelOnImage(
    //       path: pickedImagePath, // required
    //       imageMean: 0.0, // defaults to 117.0
    //       imageStd: 255.0, // defaults to 1.0
    //       numResults: 2, // defaults to 5
    //       threshold: 0.2, // defaults to 0.1
    //       asynch: true // defaults to true
    //       );
    //   if (recognitions.length > 0) {
    //     print(recognitions[0]['confidence']);
    //     double percentage = (1 - recognitions[0]['confidence']) * 100;
    //     AwesomeDialog(
    //       context: context,
    //       dialogType: percentage < 50 ? DialogType.SUCCES : DialogType.ERROR,
    //       title: "Results",
    //       body: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Text(
    //             percentage < 50 ? "Covid Negative" : "Covid Positive",
    //             style: GoogleFonts.aleo(
    //               color: percentage < 50 ? Colors.green : Colors.red,
    //               fontSize: 22,
    //             ),
    //           ),
    //           SizedBox(height: 5),
    //           Text(
    //             "There is " +
    //                 percentage.toStringAsFixed(2) +
    //                 "% chance that your are covid positive.",
    //             style: GoogleFonts.aleo(
    //               color: Colors.grey[400],
    //               fontSize: 15,
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //         ],
    //       ),
    //     )..show();
    //   } else {
    //     AwesomeDialog(
    //       context: context,
    //       dialogType: DialogType.ERROR,
    //       title: "Results",
    //       body: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Text(
    //             "Covid Positive",
    //             style: GoogleFonts.aleo(
    //               color: Colors.red,
    //               fontSize: 22,
    //             ),
    //           ),
    //           SizedBox(height: 5),
    //           Text(
    //             "There is " +
    //                 "61.89" +
    //                 "% chance that your are covid positive.",
    //             style: GoogleFonts.aleo(
    //               color: Colors.grey[400],
    //               fontSize: 15,
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //         ],
    //       ),
    //     )..show();
    //   }
    // } catch (e) {
    //   // TODO
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.ERROR,
    //     title: "Results",
    //     body: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Text(
    //           "Covid Positive",
    //           style: GoogleFonts.aleo(
    //             color: Colors.red,
    //             fontSize: 22,
    //           ),
    //         ),
    //         SizedBox(height: 5),
    //         Text(
    //           "There is " + "61.89" + "% chance that your are covid positive.",
    //           style: GoogleFonts.aleo(
    //             color: Colors.grey[400],
    //             fontSize: 15,
    //           ),
    //           textAlign: TextAlign.center,
    //         ),
    //       ],
    //     ),
    //   )..show();
    // }
    // // var recognitions = await Tflite.runModelOnBinary(
    // //     binary: imageToByteListFloat32(decodeImage(File(pickedImagePath).readAsBytesSync()), 32, 127.5, 127.5), // required
    // //     numResults: 6, // defaults to 5
    // //     threshold: 0.05, // defaults to 0.1
    // //     asynch: true // defaults to true
    // //     );
    var formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(pickedImagePath),
    });
    setState(() {
      isLoading = true;
    });
    var response = await Dio().post(
        'https://limitless-cliffs-84762.herokuapp.com/py',
        data: formData);
    print(response.data);
    setState(() {
      isLoading = false;
    });
    AwesomeDialog(
      context: context,
      dialogType: response.data.toString() == "COVID"
          ? DialogType.ERROR
          : DialogType.SUCCES,
      title: "Results",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            response.data.toString() == "COVID"
                ? "Covid Positive"
                : "Covid Negative",
            style: GoogleFonts.aleo(
              color: response.data.toString() == "COVID"
                  ? Colors.red
                  : Colors.green,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 5),
          Text(
            response.data.toString() == "COVID"
                ? "There is a chance that you are covid positive. Please don't consider this as your final report."
                : "",
            style: GoogleFonts.aleo(
              color: Colors.grey[400],
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )..show();
  }
}
