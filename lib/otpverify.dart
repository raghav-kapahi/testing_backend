import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'homepage.dart';

class otpVerify extends StatefulWidget {
  final String mobNumb;
  otpVerify(this.mobNumb);
  @override
  State<otpVerify> createState() => _otpVerifyState();
}

class _otpVerifyState extends State<otpVerify> {
  final _auth = FirebaseAuth.instance;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  static const focusedBorderColor = Colors.blueGrey;
  static const fillColor = Color.fromRGBO(243, 246, 249, 0);
  static const borderColor = Colors.black;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: borderColor),
        color: Colors.white),
  );
  late String _verificationCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7e8d1),
      appBar: AppBar(
        leadingWidth: 10.0,
        backgroundColor: Color(0xff040720),
        title: Center(
          child: Text(
            'OTP VERIFICATION',
            style: TextStyle(color: Colors.white, fontFamily: 'Koho'),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'VERIFY ${widget.mobNumb}',
              style: TextStyle(fontFamily: 'Koho', fontSize: 30.0),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Pinput(
              length: 6,
              onSubmitted: (pin) async {
                await _auth
                    .signInWithCredential(PhoneAuthProvider.credential(
                        verificationId: _verificationCode, smsCode: pin))
                    .then((value) async {
                  if (value.user != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => homepage()));
                  }
                });
              },
              controller: pinController,
              focusNode: focusNode,
              // androidSmsAutofillMethod:
              //     AndroidSmsAutofillMethod.smsUserConsentApi,
              // listenForMultipleSmsOnAndroid: true,
              // defaultPinTheme: defaultPinTheme,
              // validator: (value) {
              //   return value == '2222' ? null : 'Pin is incorrect';
              // },
              // onClipboardFound: (value) {
              //   debugPrint('onClipboardFound: $value');
              //   pinController.setText(value);
              // },
              // hapticFeedbackType: HapticFeedbackType.lightImpact,
              // onCompleted: (pin) {
              //   debugPrint('onCompleted: $pin');
              // },
              // onChanged: (value) {
              //   debugPrint('onChanged: $value');
              // },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Card(
                    elevation: 20,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: 22,
                      height: 1,
                      color: focusedBorderColor,
                    ),
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _verifyPhone() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: '+91${widget.mobNumb}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => homepage()));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationID, int? resendToken) async {
          assert(resendToken != null);
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}
