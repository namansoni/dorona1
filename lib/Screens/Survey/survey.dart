//import 'dart:async';
//import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:checkbox/app/last_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.orangeAccent),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _animateController;
  AnimationController _longPressController;
  AnimationController _secondStepController;
  AnimationController _thirdStepController;
  AnimationController _fourStepController;
  AnimationController _fifthStepController;

  double overall = 3.0;
  String overallStatus = "Sometimes";
  int curIndex = 0;
  String usingTimes = 'Shared a home';
  double counter=0;
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

  Animation<double> longPressAnimation;
  Animation<double> secondTranformAnimation;
  Animation<double> thirdTranformAnimation;
  Animation<double> fourTranformAnimation;
  Animation<double> fifthTranformAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animateController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _longPressController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _secondStepController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _thirdStepController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _fourStepController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _fifthStepController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    longPressAnimation =
        Tween<double>(begin: 1.0, end: 2.0).animate(CurvedAnimation(
            parent: _longPressController,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.fastOutSlowIn,
            )));

    fourTranformAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _fourStepController,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.fastOutSlowIn,
            )));
    fifthTranformAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _fifthStepController,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.fastOutSlowIn,
            )));


    secondTranformAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _secondStepController,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.fastOutSlowIn,
            )));

    thirdTranformAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _thirdStepController,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.fastOutSlowIn,
            )));

    _longPressController.addListener(() {
      setState(() {});
    });

    _secondStepController.addListener(() {
      setState(() {});
    });

    _thirdStepController.addListener(() {
      setState(() {});
    });

    _fourStepController.addListener(() {
      setState(() {});
    });
    _fifthStepController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animateController.dispose();
    _secondStepController.dispose();
    _thirdStepController.dispose();
    _fourStepController.dispose();
    _fifthStepController.dispose();
    _longPressController.dispose();
    super.dispose();
  }

  Future _startAnimation() async {
    try {
      await _animateController.forward().orCancel;
      setState(() {});
    } on TickerCanceled {}
  }

  Future _startLongPressAnimation() async {
    try {
      await _longPressController.forward().orCancel;
    } on TickerCanceled {}
  }

  Future _startSecondStepAnimation() async {
    try {
      await _secondStepController.forward().orCancel;
    } on TickerCanceled {}
  }

  Future _startThirdStepAnimation() async {
    try {
      await _thirdStepController.forward().orCancel;
    } on TickerCanceled {}
  }

  Future _startFourStepAnimation() async {
    try {
      await _fourStepController.forward().orCancel;
    } on TickerCanceled {}
  }

  Future _startFifthStepAnimation() async {
    try {
      await _fifthStepController.forward().orCancel;
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;

    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: _animateController.isCompleted
              ? getPages(_width)
              : AnimationBox(
            controller: _animateController,
            screenWidth: _width - 32.0,
            onStartAnimation: () {
              _startAnimation();
            },
          ),
        ),
      ),
      bottomNavigationBar: _animateController.isCompleted
          ? BottomAppBar(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey.withAlpha(200))]),
            height: 50.0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  curIndex += 1;
                  if (curIndex == 1) {
                    counter=counter+overall-1;
                    _startSecondStepAnimation();
                  } else if (curIndex == 2) {
                    counter=counter+double.tryParse(usingTimes);
                    _startThirdStepAnimation();
                  } else if (curIndex == 3) {
                    if(thirdQuestionList[8].isSelected==true) {
                        counter = counter + 0;
                      }
                    else{
                      if(thirdQuestionList[0].isSelected==true)
                        counter+=1;
                      if(thirdQuestionList[1].isSelected==true)
                        counter+=1;
                      if(thirdQuestionList[2].isSelected==true)
                        counter+=2;
                      if(thirdQuestionList[3].isSelected==true)
                        counter+=2;
                      if(thirdQuestionList[4].isSelected==true)
                        counter+=2;
                      if(thirdQuestionList[5].isSelected==true)
                        counter+=2;
                      if(thirdQuestionList[6].isSelected==true)
                        counter+=3;
                      if(thirdQuestionList[7].isSelected==true)
                        counter+=3;


                    }
                    print(counter);
                    _startFourStepAnimation();
                  }
                  else if(curIndex==4){
                    print("END");
                    _startFifthStepAnimation();
                  }
                });
              },
              child: Center(
                  child: Text(
                    curIndex < 3 ? 'Continue' : 'Finish',
                    style: TextStyle(fontSize: 20.0, color: Colors.orangeAccent),
                  )),
            ),
          ))
          : null,
    );
  }

  Widget getPages(double _width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
//                color: Colors.blue,
          margin: EdgeInsets.only(top: 30.0),
          height: 10.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(4, (int index) {
              return Container(
                decoration: BoxDecoration(
//                    color: Colors.orangeAccent,
                  color: index <= curIndex ? Colors.orangeAccent : Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                height: 10.0,
                width: (_width - 32.0 - 15.0) / 4.0,
                margin: EdgeInsets.only(left: index == 0 ? 0.0 : 5.0),
              );
            }),
          ),
        ),
        curIndex == 0
            ? _getFirstStep()
            : curIndex == 1
            ? _getSecondStep()
            : curIndex == 2 ? _getThirdStep() :curIndex==3? _getFourStep():_getFifthStep(),
      ],
    );
  }

  Widget _getFirstStep() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 34.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Question 1'),
            Container(
                margin: EdgeInsets.only(top: 16.0),
                child: Text('How frequently do you visit public places?')),
            Container(
              margin: EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                overallStatus,
                style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Center(
                child: Slider(
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
      ),
    );
  }

  Widget _getSecondStep() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 34.0),
        child: Transform(
          transform: new Matrix4.translationValues(
              0.0, 50.0 * (1.0 - secondTranformAnimation.value), 0.0),
          child: Opacity(
            opacity: secondTranformAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Question 2'),
                Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text('Within the past 14 days, have you had any of these type of contact with a COVID positive person?')),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 258.0,
                      child: Card(
                        child: Column(
                          children: List.generate(usingCollection.length,
                                  (int index) {
                                final using = usingCollection[index];
                                return GestureDetector(
                                  onTapUp: (detail) {
                                    setState(() {
                                      usingTimes = using.identifier;
                                      //print(usingTimes);
                                    });
                                  },
                                  child: Container(
                                    height: 50.0,
                                    color: usingTimes == using.identifier
                                        ? Colors.orangeAccent.withAlpha(100)
                                        : Colors.white,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Radio(
                                                activeColor: Colors.orangeAccent,
                                                value: using.identifier,
                                                groupValue: usingTimes,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    usingTimes = value;
                                                  });
                                                }),
                                            Text(using.displayContent)
                                          ],
                                        ),
                                        Divider(
                                          height: index < usingCollection.length
                                              ? 1.0
                                              : 0.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
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
  Widget _getThirdStep() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 34.0),
        child: Transform(
          transform: new Matrix4.translationValues(
              0.0, 50.0 * (1.0 - thirdTranformAnimation.value), 0.0),
          child: Opacity(
            opacity: thirdTranformAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Question 3'),
                Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text('Do you have any of the following symptoms?')),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 500.0,
                      child: Card(
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
                                            ? Colors.orangeAccent.withAlpha(100)
                                            : Colors.white,
                                        child: Row(
                                          children: <Widget>[
                                            Checkbox(
                                                activeColor: Colors.orangeAccent,
                                                value: question.isSelected,
                                                onChanged: (bool value) {
//                                          print(value);
                                                  setState(() {
                                                    question.isSelected = value;
                                                    //print(question.isSelected);
                                                  });
                                                }),
                                            Text(question.displayContent)
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFourStep() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 34.0),
        child: Transform(
          transform: new Matrix4.translationValues(
              0.0, 50.0 * (1.0 - secondTranformAnimation.value), 0.0),
          child: Opacity(
            opacity: secondTranformAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Question 4'),
                Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text('Have you been advised to get COVID-19 testing by a public health official?')),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 258.0,
                      child: Card(
                        child: Column(
                          children: List.generate(usingCollection2.length,
                                  (int index) {
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
                                        ? Colors.orangeAccent.withAlpha(100)
                                        : Colors.white,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Radio(
                                                activeColor: Colors.orangeAccent,
                                                value: using.identifier,
                                                groupValue: usingTimes,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    usingTimes = value;
                                                    //print(usingTimes);
                                                  });
                                                }),
                                            Text(using.displayContent)
                                          ],
                                        ),
                                        Divider(
                                          height: index < usingCollection.length
                                              ? 1.0
                                              : 0.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFifthStep() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 34.0),
        child: Transform(
          transform: new Matrix4.translationValues(
              0.0, 50.0 * (1.0 - secondTranformAnimation.value), 0.0),
          child: Opacity(
            opacity: secondTranformAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Result: '),
                Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text('Thankyou for taking the self assessment test. The results are:')),
                Container(
                    margin: EdgeInsets.only(top: 106.0),
                    child: Text(counter<8?"You are at low risk of having COVID-19":counter<15?"You are at moderate risk of having COVID-19":"You are at high risk of having COVID-19",
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.normal,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,)
                ),

                Container(

                  child:Image.asset(counter<8?'assets/images/low.png':counter<15?'assets/images/mild.jpg':'assets/images/high.png',height:100,width: 100),
                ),
                Container(
                    margin: EdgeInsets.only(top: 136.0),
                    child: Text(counter<8?"Clean your hands often.\nUse soap and water, or an alcohol-based hand rub.\nMaintain a safe distance from anyone who is coughing or sneezing.\nWear a mask when physical distancing is not possible.\nDon’t touch your eyes, nose or mouth.\nCover your nose and mouth with your bent elbow or a tissue when you cough or sneeze.":counter<15?"If you feel sick you should rest, drink plenty of fluid, and eat nutritious food.\nStay in a separate room from other family members, and use a dedicated bathroom if possible.\nClean and disinfect frequently touched surfaces.\nIf you have difficulty breathing, seek medical attention.":"Seek immediate medical attention.\nIsolate yourself untill help arrives.\nGet yourself tested for COVID-19",
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0),
                      textAlign: TextAlign.left,)
                )

              ],
            ),
          ),
        ),
      ),
    );
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
}

class AnimationBox extends StatelessWidget {
  AnimationBox(
      {Key key, this.controller, this.screenWidth, this.onStartAnimation})
      : width = Tween<double>(
    begin: screenWidth,
    end: 40.0,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.1,
        0.3,
        curve: Curves.fastOutSlowIn,
      ),
    ),
  ),
        alignment = Tween<AlignmentDirectional>(
          begin: AlignmentDirectional.bottomCenter,
          end: AlignmentDirectional.topStart,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3,
              0.6,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        radius = BorderRadiusTween(
          begin: BorderRadius.circular(20.0),
          end: BorderRadius.circular(2.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.6,
              0.8,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(
          begin: 40.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3,
              0.8,
              curve: Curves.ease,
            ),
          ),
        ),
        movement = EdgeInsetsTween(
          begin: EdgeInsets.only(top: 0.0),
          end: EdgeInsets.only(top: 30.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3,
              0.6,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        scale = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.8,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        opacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.8,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        numberOfStep = IntTween(
          begin: 1,
          end: 4,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.8,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        super(key: key);

  final VoidCallback onStartAnimation;
  final Animation<double> controller;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<AlignmentDirectional> alignment;
  final Animation<BorderRadius> radius;
  final Animation<EdgeInsets> movement;
  final Animation<double> opacity;
  final Animation<double> scale;
  final Animation<int> numberOfStep;
  final double screenWidth;
  final double overral = 3.0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Stack(
          alignment: alignment.value,
          children: <Widget>[
            Opacity(
              opacity: 1.0 - opacity.value,
              child: Column(
                children: <Widget>[
                  Container(
//                color: Colors.blue,
                    margin: EdgeInsets.only(top: 30.0),
                    height: 10.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(numberOfStep.value, (int index) {
                        return Container(
                          decoration: BoxDecoration(
//                    color: Colors.orangeAccent,
                            color:
                            index == 0 ? Colors.orangeAccent : Colors.grey,
                            borderRadius:
                            BorderRadius.all(Radius.circular(2.0)),
                          ),
                          height: 10.0,
                          width: (screenWidth - 15.0) / 5.0,
                          margin: EdgeInsets.only(left: index == 0 ? 0.0 : 5.0),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: Container(
//                color: Colors.blue,
                      margin: EdgeInsets.only(top: 34.0),
//                height: 10.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Question 1'),
                          Container(
                              margin: EdgeInsets.only(top: 16.0),
                              child: Text(
                                  'How frequently do you visit public places?')),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 50.0),
                            child: Text(
                              'Sometimes',
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity:
              controller.status == AnimationStatus.dismissed ? 1.0 : 0.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: Center(
                          child: FlutterLogo(
                            //colors: Colors.orange,
                            size: 100.0,
                          ))),
                  Text(
                    'COVID-19 SURVEY by Dorona ',
                    style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 120.0),
                    child: Text(
                      'Answer the questions to predict your health status',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Opacity(
              opacity: opacity.value,
              child: GestureDetector(
                onTap: onStartAnimation,
                child: Transform.scale(
                  scale: scale.value,
                  child: Container(
                    margin: movement.value,
                    width: width.value,
                    child: GestureDetector(
                      child: Container(
                        height: height.value,
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: radius.value),
                        child: Center(
                          child: controller.status == AnimationStatus.dismissed
                              ? Text(
                            'Take the survey',
                            style: TextStyle(
                                color: Colors.white, fontSize: 20.0),
                          )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
//            Opacity(
//              opacity: 1.0 - opacity.value,
//              child:
//            ),
          ],
        );
      },
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