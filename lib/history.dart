import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pushing_notification/bookings.dart';
import 'package:pushing_notification/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:pushing_notification/main.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'homepage.dart';
import 'bookings.dart';

int pageIndex=2;
class history extends StatefulWidget {
  history(int index)
  {
    pageIndex=index;
  }
  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {

  Widget? _child;


  @override
  void initState() {
    _child = history(pageIndex);
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
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => homepage(pageIndex)));
            // Navigator.of(context)
            //     .popUntil(ModalRoute.withName("/homepage"));
            break;
          }
        case 2:
          {
            _child =history(pageIndex);
            index=1;
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => history(pageIndex)));
            // Navigator.of(context)
            //     .popUntil(ModalRoute.withName("/history"));
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
      body: Center(child: Text('hi i am history')),
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
