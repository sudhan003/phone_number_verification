import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phone_number_verification/screens/otp_verification_screen.dart';
import 'dart:async';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //firebase Phone number verification
  TextEditingController phoneNumberController =
      TextEditingController(text: '+919943312165');
  verifyPhoneNumber(BuildContext context) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumberController.text,
          verificationCompleted: (AuthCredential authCredential) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Verification completed"),
                backgroundColor: Colors.green,
              ),
            );
          },
          verificationFailed: (FirebaseException exception) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Verification failed"),
                backgroundColor: Colors.red,
              ),
            );
          },
          codeSent: (String? verId, int? forceCodeResent) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Code sent successfully"),
              backgroundColor: Colors.green,
            ));

            verificationId = verId;
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => OtpVerificationScreen()));
          },
          codeAutoRetrievalTimeout: (verId) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Time out"),
              backgroundColor: Colors.red,
            ));
          });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  TextEditingController otpController = TextEditingController();

  String? verificationId;
  signinWithPhone(BuildContext context) async {
    try {
      if (verificationId != null) {
        await firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(
            verificationId: verificationId!, smsCode: otpController.text));
        _stopTimer();
      }
      // sign-in successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        _showInvalidCodeSnackbar(context);
      } else {
        _showInvalidCodeSnackbar(context);
      }
    }
  }

  int _invalidCodeCount = 0;
  bool _isTimerRunning = false;
  Timer? _timer;
  int _remainingAttempts = 5;
  void _showInvalidCodeSnackbar(BuildContext context) {
    _invalidCodeCount++;

    if (_invalidCodeCount >= 5 && !_isTimerRunning) {
      _isTimerRunning = true;
      _remainingAttempts = 0;

      // start timer
      _timer = Timer.periodic(Duration(seconds: 30), (timer) {


          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Too many attempts. Please try again later. ${_timer!.tick}s remaining',
              ),
              duration: Duration(seconds: 30),
            ),
          );
        } );

      // show timer in UI
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Too many attempts. Please try again later.'),
      //     duration: Duration(seconds: 10),
      //   ),
      // );
    } else if (!_isTimerRunning) {
      _remainingAttempts = 5 - _invalidCodeCount;
      String message =
          'Invalid code. Please try again. $_remainingAttempts attempts remaining.';

      // if (_remainingAttempts == 1) {
      //   // start timer if this is the last attempt
      //   _isTimerRunning = true;
      //   _timer = Timer(Duration(seconds: 30), () {
      //     _isTimerRunning = false;
      //     _invalidCodeCount = 0;
      //     _remainingAttempts = 5;
      //     _stopTimer();
      //   });
      //
      //   message =
      //       'Invalid code. Please try again. You have 1 attempt remaining. Next attempt is locked for 30 seconds.';
      // }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isTimerRunning = false;
    _invalidCodeCount = 0;
  }

  resendCode() {
    if (_isTimerRunning) {
      _stopTimer();
    }
    _invalidCodeCount = 0;
  }

  signOut() async {
    await firebaseAuth.signOut();
  }
}
