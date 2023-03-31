import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phone_number_verification/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:pinput/pinput.dart';
import '../keys.dart';
import 'home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
   OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final focusNode = FocusNode();
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Colors.grey;
    const fillColor = Colors.black54;
    const borderColor = Colors.black;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return Scaffold(
            body: Consumer<AuthProvider>(builder: (context, model, _) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/otp.svg',
                        width: 400,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Pinput(
                        length: 6,
                        controller: model.otpController,
                        focusNode: focusNode,
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        listenForMultipleSmsOnAndroid: true,
                        defaultPinTheme: defaultPinTheme,
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        // validator: (value) {
                        //   if(value == null || value.isEmpty){
                        //     return 'Please enter OTP';
                        //   }
                        //   else if(value.length != 6){
                        //     return 'Please enter 6 digit OTP';
                        //   }
                        // },
                        onCompleted: (pin) {
                          debugPrint('onCompleted: $pin');
                        },
                        onChanged: (value) {
                          debugPrint('onChanged: $value');
                        },
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: 22,
                              height: 1,
                              color: focusedBorderColor,
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
                      TextButton(
                        onPressed: () {
                          model.signinWithPhone(context);
                        },
                        child: const Text("Submit"),
                      ),
                      Row(children: [
                        const Text("Didn't receive OTP"),
                        TextButton(
                          onPressed: () {
                            model.verifyPhoneNumber(context);
                            model.resendCode();
                          },
                          child: const Text("re-send OTP"),
                        ),
                      ])
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
}
