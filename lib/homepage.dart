import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pushing_notification/bookings.dart';
import 'package:pushing_notification/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:pushing_notification/main.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

int pageIndex=1;
class introscreenHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        color: Colors.black,
      ),
      nextScreen: homepage(pageIndex),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}

class homepage extends StatefulWidget {
  homepage(int index)
  {
    pageIndex=index;
  }

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  Widget? _child;


  @override
  void initState() {
    _child = homepage(pageIndex);
    super.initState();
  }
  void _handleNavigationChange(int index) {
    pageIndex=index;
    setState(() {
      switch (index) {
        case 0:
          {
            _child =bookings(pageIndex);
            index=1;
                // Navigator.push(
                // context,
                // MaterialPageRoute(
                //     builder: (context) => bookings(pageIndex)));
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => bookings(pageIndex)),
                    (Route route) => false);
                break;
          }
        case 1:
          {
            _child =homepage(pageIndex);
            index=1;
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => homepage(pageIndex)),
                    (Route route) => false);
            break;
          }
        case 2:
          {
            _child =history(pageIndex);
            index=1;
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => history(pageIndex)),
                    (Route route) => false);
            break;
          }
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
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
      body: Center(child: Text("hello")),
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
              icon: Icons.menu_book,
              backgroundColor: Color(0xff040720),
              extras: {"label": "home"}
          ),
          FluidNavBarIcon(
              icon: Icons.home,
              backgroundColor: Color(0xff040720),
              extras: {"label": "bookmark"}
          ),
          FluidNavBarIcon(
              icon: Icons.history,
              backgroundColor: Color(0xff040720),
              extras: {"label": "partner"}
          ),
        ],
        onChange: _handleNavigationChange,
        style: FluidNavBarStyle(iconUnselectedForegroundColor: Colors.white,iconSelectedForegroundColor: Color(0xfff7e8d1)),
        scaleFactor: 1.5,
        defaultIndex: pageIndex,
        itemBuilder: (icon, item) => Semantics(
          label: icon.extras!["label"],
          child: item,
        ),
      ),
    );
  }
}
