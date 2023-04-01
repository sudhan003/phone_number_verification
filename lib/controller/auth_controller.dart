import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number_verification/screens/home_screen.dart';
import 'package:phone_number_verification/screens/phone_number_screen.dart';
import 'package:timer_snackbar/timer_snackbar.dart';
import '../screens/otp_verification_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    super.onReady();

    ever(_user, _initialScreen);
  }

  String? userNumber;
  _initialScreen(User? user) {
    userNumber = user?.phoneNumber;
    if (user == null) {
      Get.offAll(() => const PhoneNumberScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();
  String? verificationId;

  Future<void> verifyPhoneNumber(BuildContext context) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber:
              countryCodeController.text + phoneNumberController.text.trim(),
          timeout: const Duration(seconds: 50),
          verificationCompleted: (AuthCredential authCredential) {
            Get.snackbar(
              'about user',
              'usermessage',
              snackPosition: SnackPosition.BOTTOM,
              titleText: const Text("verification"),
              messageText: const Text("verification Completed"),
              backgroundColor: Colors.greenAccent,
            );
          },
          verificationFailed: (FirebaseException exception) {
            Get.snackbar('about user', 'usermessage',
                snackPosition: SnackPosition.BOTTOM,
                titleText: const Text("verification"),
                messageText: const Text("verification failed"),
                backgroundColor: Colors.redAccent);
          },
          codeSent: (String? verId, int? forceCodeResent) {
            Get.snackbar('about user', 'usermessage',
                snackPosition: SnackPosition.BOTTOM,
                titleText: const Text("verification"),
                messageText: const Text("Code sent successfully"),
                backgroundColor: Colors.greenAccent);

            verificationId = verId;
            Get.to(() => const OtpVerificationScreen());
          },
          codeAutoRetrievalTimeout: (verId) {});
    } on FirebaseException catch (e) {
      Get.snackbar('about user', 'usermessage',
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text("error"),
          messageText: Text(e.message!),
          backgroundColor: Colors.redAccent);
    }
  }

  Future<void> resendOTP(BuildContext context) async {
    resendCode();
    try {
      await auth.verifyPhoneNumber(
          phoneNumber:
              countryCodeController.text + phoneNumberController.text.trim(),
          timeout: const Duration(seconds: 50),
          verificationCompleted: (AuthCredential authCredential) {
            Get.snackbar('about user', 'usermessage',
                snackPosition: SnackPosition.BOTTOM,
                titleText: const Text("verification"),
                messageText: const Text("verification Completed"),
                backgroundColor: Colors.greenAccent);
          },
          verificationFailed: (FirebaseException exception) {
            Get.snackbar('about user', 'usermessage',
                snackPosition: SnackPosition.BOTTOM,
                titleText: const Text("verification"),
                messageText: const Text("verification failed"),
                backgroundColor: Colors.redAccent);
          },
          codeSent: (String? verId, int? forceCodeResent) {
            Get.snackbar('about user', 'usermessage',
                snackPosition: SnackPosition.BOTTOM,
                titleText: const Text("verification"),
                messageText: const Text("Code sent successfully"),
                backgroundColor: Colors.redAccent);

            verificationId = verId;
            Get.to(() => const OtpVerificationScreen());
          },
          codeAutoRetrievalTimeout: (verId) {});
    } on FirebaseException catch (e) {
      Get.snackbar('about user', 'usermessage',
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text("error"),
          messageText: Text(e.message!),
          backgroundColor: Colors.redAccent);
    }
  }

  resendCode() {
    _invalidCodeCount = 0;
  }

  signOut() async {
    await auth.signOut();
  }

  int _invalidCodeCount = 0;
  bool _isTimerRunning = false;
  Timer? _timer;

  void _showInvalidCodeSnackbar(BuildContext context) {
    _invalidCodeCount++;

    if (_invalidCodeCount >= 5 && !_isTimerRunning) {
      _isTimerRunning = true;

      // start timer
      _timer = Timer(const Duration(seconds: 10), () {
        _isTimerRunning = false;
        _invalidCodeCount = 0;
        _stopTimer();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: timerSnackbar(
          context: context,
          contentText: "Too many attempts. Try again later",
          afterTimeExecute: () => Get.snackbar('about user', 'usermessage',
              snackPosition: SnackPosition.BOTTOM,
              titleText: const Text("permission:"),
              messageText: const Text(
                "Enter otp now",
                style: TextStyle(fontSize: 20),
              ),
              backgroundColor: Colors.greenAccent),
          second: 10,
        ),
      ));
    } else {
      String message = "Invalid code. ";
      int remainingAttempts = 5 - _invalidCodeCount;
      if (remainingAttempts <= 0) {
        return;
      } else if (remainingAttempts == 1) {
        Get.snackbar('about user', 'usermessage',
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text("Attempts"),
            messageText: Text(message += '1 attempt remaining.'),
            backgroundColor: Colors.redAccent);
      } else {
        Get.snackbar('about user', 'usermessage',
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text("Attempts"),
            messageText:
                Text(message += '$remainingAttempts attempts remaining.'),
            backgroundColor: Colors.redAccent);
      }
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isTimerRunning = false;
    _invalidCodeCount = 0;
  }

  var otpNumberController = TextEditingController();

  void signinWithPhone(BuildContext context) async {
    try {
      await auth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: otpNumberController.text));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        _showInvalidCodeSnackbar(context);
      } else {
        _showInvalidCodeSnackbar(context);
      }
    }
  }
}
