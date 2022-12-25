import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pushing_notification/bookings.dart';
import 'package:pushing_notification/history.dart';
import 'package:pushing_notification/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:pushing_notification/main.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class introUserDetails extends StatelessWidget {
  const introUserDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        color: Colors.black,
      ),
      nextScreen: userDetails(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}

class userDetails extends StatefulWidget {
  const userDetails({Key? key}) : super(key: key);

  @override
  State<userDetails> createState() => _userDetailsState();
}

class _userDetailsState extends State<userDetails> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController insUsername = TextEditingController();
  //text editing controller for text field

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }
  @override
late String Name;
  late String formattedDate;
  late String instaUsername;
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Color(0xfff7e8d1),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.logout),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool("isLoggedIn", false);
            final userSignOut = await _auth.signOut();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => introscreenmain()),
                    (Route route) => false);
          }),
      body:  Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 20,
            child: Text("Let Us Know a Little Bit More About You",
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Koho',
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
            ),
          ),
          SizedBox(height: 30),

          TextFormField(
            controller: name,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (value) {
              Name = value;
            },
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter your name',
              labelText: 'Name',
            ),
          ),
          TextFormField(
            controller: insUsername,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (value) {
              instaUsername = value;
            },
            decoration: const InputDecoration(
              icon: FaIcon(FontAwesomeIcons.instagram),
              hintText: 'Enter your Instagram Username',
              labelText: 'Username',
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },

            controller: dateinput, //editing controller of this TextField
            decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                hintText: "Enter Your Date Of Birth",//icon of text field
                labelText: "DOB" //label text of field
            ),
            readOnly: true,  //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context, initialDate: DateTime.now(),
                firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime.now(),
              );
              if(pickedDate != null ){
                formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() {
                  name.text=Name;
                  insUsername.text=instaUsername;
                  dateinput.text = formattedDate; //set output date to TextField value.
                });
              }else{
                print("Date is not selected");
              }
            },


          ),
          SizedBox(
            height: 40,
          ),
          Container(
            width: 300,
            height: 40,
            child: ElevatedButton(
              child: Text(
                'SUBMIT',
                style: TextStyle(color: Colors.black, fontFamily: 'Koho'),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a Snackbar.
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => introscreenHome()),
                          (Route route) => false);
                }

              },
            ),
          ),

        ],
      ),
    ),
    );
  }
}



