import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';
import 'package:pushing_notification/homepage.dart';
import 'package:pushing_notification/main.dart';
import 'otpverify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class introscreenlogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        color: Colors.black,
      ),
      nextScreen: login(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7e8d1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 25, fontFamily: 'Koho'),
                  decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      hintText: "Enter your email id",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      counterText: ""),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 25, fontFamily: 'Koho'),
                  decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      counterText: ""),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 120,
              height: 40,
              child: ElevatedButton(

                child: Text(
                  'LOGIN',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Koho', fontSize: 15),
                ),
                onPressed: () async {
                  try {
                    final User = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (User != null) {
                      // print(checkStatus['status']);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("isLoggedIn", true);
                      var status = prefs.getBool("isLoggedIn");
                      //print(status);
                      //checkStatus['status'] = true;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => introscreenHome()));
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => introscreenHome()),
                          (Route route) => false);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
