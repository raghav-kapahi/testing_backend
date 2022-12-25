import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pushing_notification/homepage.dart';
import 'package:pushing_notification/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import "dart:async";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class introscreenmain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        color: Colors.black,
      ),
      nextScreen: MyHomePage(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}

Future<bool> myScreenDecide() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? status = 0 > 1;
  status = prefs.getBool('isLoggedIn');
  print(status);


  if (status == null || status == false) {
    return Future<bool>.value(false);
  } else {
    return Future<bool>.value(true);
  }
}

class MyApp extends StatelessWidget {
  bool myVar = false;
  MyApp() {
    var check = myScreenDecide().then((value) {
      myVar = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: myVar == false ? introscreenmain() : introscreenHome(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7e8d1),
      appBar: AppBar(
        backgroundColor: Color(0xff040720),
        title: Center(
          child: Text(
            'MY APP',
            style: TextStyle(color: Colors.white, fontFamily: 'Koho'),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
                pause: Duration(milliseconds: 100),
                isRepeatingAnimation: false,
                animatedTexts: [
                  FadeAnimatedText(
                    'Welcome',
                    textStyle: TextStyle(fontSize: 20.0, fontFamily: 'Koho'),
                  ),
                  FadeAnimatedText(
                    'To',
                    textStyle: TextStyle(fontSize: 20.0, fontFamily: 'Koho'),
                  ),
                  FadeAnimatedText(
                    'My',
                    textStyle: TextStyle(fontSize: 20.0, fontFamily: 'Koho'),
                  ),
                  FadeAnimatedText(
                    'Application',
                    textStyle: TextStyle(fontSize: 20.0, fontFamily: 'Koho'),
                  )
                ]),
            SizedBox(
              height: 60.0,
            ),
            Container(
              width: 300,
              height: 40,
              child: ElevatedButton(
                child: Text(
                  'SIGN UP',
                  style: TextStyle(color: Colors.black, fontFamily: 'Koho'),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => introscreensignup()));
                },
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            Container(
              width: 301,
              height: 40,
              child: ElevatedButton(
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(10.0),
                // ),
                // elevation: 20.0,
                // color: Color(0xffc9f7f6),
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.black, fontFamily: 'Koho'),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => introscreenlogin()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
