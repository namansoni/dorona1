import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SurveyNew extends StatefulWidget {
  @override
  _SurveyNewState createState() => _SurveyNewState();
}

class _SurveyNewState extends State<SurveyNew> {
  AnimationController animationController,
      firstWidgetController,
      question1Controller;
  List isQuestion = [false, false, false, false, false];
  double overall = 3.0;
  String overallStatus = "Sometimes";
  int curIndex = 0;
  String usingTimes = 'Shared a home';
  double counter = 0;
  bool isFairly = false;
  bool isClear = false;
  bool isEasy = false;
  bool isFriendly = false;
  List<SecondQuestion> usingCollection = [
    SecondQuestion('1', 'Shared a home'),
    SecondQuestion('3', 'Been sneezed or coughed on'),
    SecondQuestion('2', 'Shared items'),
    SecondQuestion('4', 'Hugged or Kissed'),
    SecondQuestion('0', 'None of The Above'),
  ];

  List<SecondQuestion> usingCollection2 = [
    SecondQuestion('yes', 'Yes'),
    SecondQuestion('no', 'No'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: !isQuestion[0],
          child: FadeOutLeft(
            manualTrigger: true,
            controller: (controller) {
              firstWidgetController = controller;
            },
            child: Column(
              children: [
                SizedBox(height: 20),
                FadeIn(
                  child: Container(
                    width: width,
                    child: Image.asset(
                      'assets/images/doctor.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
                FadeIn(
                  child: Container(
                      width: width * 0.7,
                      padding: EdgeInsets.only(top: 10, left: 10, bottom: 2),
                      child: Text(
                        "Accurate answers help us-help you better. Medical and support staff are valuable and very limited. Be a responsible citizen.",
                        style: subtitleTextSmall,
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Visibility(
          visible: !isQuestion[0],
          child: FadeOutLeft(
            manualTrigger: true,
            controller: (controller) {
              animationController = controller;
            },
            child: FadeIn(
              child: Container(
                width: width * 0.5,
                child: RaisedButton(
                  color: blueColor,
                  animationDuration: Duration(seconds: 1),
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  onPressed: () async {
                    animationController.forward();
                    firstWidgetController.forward();
                    setState(() {
                      isQuestion[0] = true;
                    });
                    Timer(
                        Duration(
                          milliseconds: 50,
                        ), () {
                      question1Controller.forward();
                    });
                  },
                  child: Text(
                    "Okay, Got it",
                    style: buttonText,
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(visible: isQuestionVisible(0), child: question1()),
        Visibility(visible: isQuestionVisible(1), child: question2()),
        Visibility(visible: isQuestionVisible(2), child: question3()),
        Visibility(visible: isQuestionVisible(3), child: question4()),
        Visibility(visible: isQuestionVisible(4), child: endSurvey()),
        isQuestion.contains(true)
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: blueColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  height: 50.0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        curIndex += 1;
                        if (curIndex < 5) isQuestion[curIndex] = true;
                        if (curIndex == 1) {
                          counter = counter + overall - 1;
                        } else if (curIndex == 2) {
                          counter = counter + double.tryParse(usingTimes);
                        } else if (curIndex == 3) {
                          if (thirdQuestionList[8].isSelected == true) {
                            counter = counter + 0;
                          } else {
                            if (thirdQuestionList[0].isSelected == true)
                              counter += 1;
                            if (thirdQuestionList[1].isSelected == true)
                              counter += 1;
                            if (thirdQuestionList[2].isSelected == true)
                              counter += 2;
                            if (thirdQuestionList[3].isSelected == true)
                              counter += 2;
                            if (thirdQuestionList[4].isSelected == true)
                              counter += 2;
                            if (thirdQuestionList[5].isSelected == true)
                              counter += 2;
                            if (thirdQuestionList[6].isSelected == true)
                              counter += 3;
                            if (thirdQuestionList[7].isSelected == true)
                              counter += 3;
                          }
                          print(counter);
                        } else if (curIndex == 4) {
                          print("END");
                          //_startFifthStepAnimation();

                        } else if (curIndex == 5) {
                          curIndex = 0;
                          isQuestion = [false, false, false, false, false];
                        }
                      });
                    },
                    child: Center(
                        child: Text(
                      curIndex < 4 ? 'Continue' : 'Finish',
                      style:
                          TextStyle(fontSize: 20.0, color: Colors.orangeAccent),
                    )),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  bool isQuestionVisible(int index) {
    bool t = true;
    for (int i = 0; i < 5; i++) {
      if (i <= index)
        t = t && isQuestion[i];
      else
        t = t && !isQuestion[i];
    }
    return t;
  }

  Widget question1() {
    return FadeInRight(
        manualTrigger: true,
        controller: (controller) {
          question1Controller = controller;
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          margin: EdgeInsets.only(top: 34.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Center(
                  child: Text(
                    "Question 1",
                    style:
                        GoogleFonts.aleo(color: Colors.black, fontSize: 30.0),
                  ),
                ),
              ),
              Spacer(
                flex: 2,
              ),
              Container(
                child: Text(
                  'How frequently do you visit public places?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aleo(color: Colors.black, fontSize: 30.0),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 50.0),
                child: Text(
                  overallStatus,
                  style: TextStyle(
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Slider(
                    activeColor: blueColor,
                    value: overall,
                    onChanged: (value) {
                      setState(() {
                        overall = value.round().toDouble();
                        //print(overall);
                        _getOverallStatus(overall);
                      });
                    },
                    label: '${overall.toInt()}',
                    divisions: 30,
                    min: 1.0,
                    max: 5.0,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  _getOverallStatus(double overall) {
    switch (overall.toInt()) {
      case 1:
        overallStatus = 'Never';
        break;
      case 2:
        overallStatus = 'Rarely';
        break;
      case 3:
        overallStatus = 'Sometimes';
        break;
      case 4:
        overallStatus = 'Often';
        break;
      default:
        overallStatus = 'Everyday';
        break;
    }
  }

  Widget question2() {
    return FadeInRight(
      manualTrigger: true,
      controller: (controller) {
        question1Controller = controller;
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          margin: EdgeInsets.only(top: 34.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                  child: Text(
                'Question 2',
                style: GoogleFonts.aleo(color: Colors.black, fontSize: 30.0),
              )),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Within the past 14 days, have you had any of these type of contact with a COVID positive person?',
                      style:
                          GoogleFonts.aleo(color: Colors.black, fontSize: 20.0),
                      textAlign: TextAlign.center,
                    )),
              ),
              SizedBox(
                height: 22.0,
              ),
              Center(
                child: Container(
                  child: Column(
                    children:
                        List.generate(usingCollection.length, (int index) {
                      final using = usingCollection[index];
                      return GestureDetector(
                        onTapUp: (detail) {
                          setState(() {
                            usingTimes = using.identifier;
                            //print(usingTimes);
                          });
                        },
                        child: Container(
                          color: usingTimes == using.identifier
                              ? blueColor.withOpacity(0.2)
                              : Colors.white,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio(
                                      activeColor: blueColor,
                                      value: using.identifier,
                                      groupValue: usingTimes,
                                      onChanged: (String value) {
                                        setState(() {
                                          usingTimes = value;
                                        });
                                      }),
                                  Text(
                                    using.displayContent,
                                    style: GoogleFonts.aleo(fontSize: 20),
                                  )
                                ],
                              ),
                              Divider(
                                height:
                                    index < usingCollection.length ? 1.0 : 0.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<ThirdQuestion> thirdQuestionList = [
    ThirdQuestion('Cough', false),
    ThirdQuestion('Fever of 100 F (37.8 C) or above', false),
    ThirdQuestion('Sore throat', false),
    ThirdQuestion('Muscle aches', false),
    ThirdQuestion('Loss of smell or taste', false),
    ThirdQuestion('Nausea, vomiting or Headache', false),
    ThirdQuestion('Trouble breathing', false),
    ThirdQuestion('Loss os speech and movement', false),
    ThirdQuestion('None of the above', false),
  ];

  //double thirdQuestionCounter
  Widget question3() {
    return FadeInRight(
      manualTrigger: true,
      controller: (controller) {
        question1Controller = controller;
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        margin: EdgeInsets.only(top: 34.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
                child: Text(
              'Question 3',
              style: GoogleFonts.aleo(fontSize: 30.0),
            )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Do you have any of the following symptoms?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aleo(fontSize: 24.0),
                    )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 12.0),
                child: Center(
                  child: Card(
                    child: SingleChildScrollView(
                      child: Container(
                        height: 500.0,
                        child: Column(
                          children: List.generate(thirdQuestionList.length,
                              (int index) {
                            ThirdQuestion question = thirdQuestionList[index];
                            return Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTapUp: (detail) {
                                    setState(() {
                                      question.isSelected =
                                          !question.isSelected;
//                                  isFairly = !isFairly;
                                    });
                                  },
                                  child: Container(
                                    height: 50.0,
                                    color: question.isSelected
                                        ? blueColor.withOpacity(0.2)
                                        : Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Checkbox(
                                            activeColor: blueColor,
                                            value: question.isSelected,
                                            onChanged: (bool value) {
//                                          print(value);
                                              setState(() {
                                                question.isSelected = value;
                                                //print(question.isSelected);
                                              });
                                            }),
                                        Text(
                                          question.displayContent,
                                          style:
                                              GoogleFonts.aleo(fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: index < thirdQuestionList.length
                                      ? 1.0
                                      : 0.0,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget question4() {
    return FadeInRight(
      manualTrigger: true,
      controller: (controller) {
        question1Controller = controller;
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        margin: EdgeInsets.only(top: 34.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
                child: Text(
              'Question 4',
              style: GoogleFonts.aleo(fontSize: 30),
            )),
            Container(
                margin: EdgeInsets.only(top: 40.0, left: 10),
                child: Text(
                  'Have you been advised to get COVID-19 testing by a public health official?',
                  style: GoogleFonts.aleo(fontSize: 22.0),
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Container(
                  child: Column(
                    children:
                        List.generate(usingCollection2.length, (int index) {
                      final using = usingCollection2[index];
                      return GestureDetector(
                        onTapUp: (detail) {
                          setState(() {
                            usingTimes = using.identifier;
                          });
                        },
                        child: Container(
                          height: 50.0,
                          color: usingTimes == using.identifier
                              ? blueColor.withOpacity(0.2)
                              : Colors.white,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio(
                                      activeColor: blueColor,
                                      value: using.identifier,
                                      groupValue: usingTimes,
                                      onChanged: (String value) {
                                        setState(() {
                                          usingTimes = value;
                                          //print(usingTimes);
                                        });
                                      }),
                                  Text(
                                    using.displayContent,
                                    style: GoogleFonts.aleo(fontSize: 16.0),
                                  )
                                ],
                              ),
                              Divider(
                                height:
                                    index < usingCollection.length ? 1.0 : 0.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget endSurvey() {
    return FadeInRight(
      manualTrigger: true,
      controller: (controller) {
        question1Controller = controller;
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.65,
        margin: EdgeInsets.only(top: 34.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Result',
                textAlign: TextAlign.center,
                style: GoogleFonts.aleo(fontSize: 30.0),
              ),
              Container(
                  margin: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Thank You for taking the self assessment test.',
                    style: GoogleFonts.aleo(
                      fontSize: 22.0,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Container(
                  margin: EdgeInsets.only(top: 75.0),
                  child: Text(
                    counter < 8
                        ? "You are at low risk of having COVID-19"
                        : counter < 15
                            ? "You are at moderate risk of having COVID-19"
                            : "You are at high risk of having COVID-19",
                    style: TextStyle(
                        color: blueColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 25.0),
                    textAlign: TextAlign.center,
                  )),
              Container(
                child: Image.asset(
                    counter < 8
                        ? 'assets/images/low.png'
                        : counter < 15
                            ? 'assets/images/mild.jpg'
                            : 'assets/images/high.png',
                    height: 80,
                    width: 80),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                    margin: EdgeInsets.only(top: 132.0),
                    child: Text(
                      counter < 8
                          ? "Precautions:\n\nClean your hands often.\nUse soap and water, or an alcohol-based hand rub.\nMaintain a safe distance from anyone who is coughing or sneezing.\nWear a mask when physical distancing is not possible.\nDon’t touch your eyes, nose or mouth.\nCover your nose and mouth with your bent elbow or a tissue when you cough or sneeze."
                          : counter < 15
                              ? "Precautions:\n\nIf you feel sick you should rest, drink plenty of fluid, and eat nutritious food.\nStay in a separate room from other family members, and use a dedicated bathroom if possible.\nClean and disinfect frequently touched surfaces.\nIf you have difficulty breathing, seek medical attention."
                              : "Precautions:\n\nSeek immediate medical attention.\nIsolate yourself untill help arrives.\nGet yourself tested for COVID-19",
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0),
                      textAlign: TextAlign.center,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SecondQuestion {
  final String identifier;
  final String displayContent;

  SecondQuestion(this.identifier, this.displayContent);
}

class ThirdQuestion {
  final String displayContent;
  bool isSelected;

  ThirdQuestion(this.displayContent, this.isSelected);
}
