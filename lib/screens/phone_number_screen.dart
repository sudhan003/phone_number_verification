import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phone_number_verification/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../keys.dart';
import 'otp_verification_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return Scaffold(
              body: Consumer<AuthProvider>(builder: (context, model, _) {
            return Form(
                key: Keys.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/signin.svg',
                          width: 500,
                        ),
                        const Text(
                          "Login",
                          style: TextStyle(fontSize: 40),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          controller: model.phoneNumberController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            } else if (value.length != 13) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: "Phone Number",
                            hintText: "Phone Number",
                            prefixIcon: const Icon(Icons.phone),
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                              onPressed: () {
                                if (Keys.formKey.currentState!.validate()) {
                                  model.verifyPhoneNumber(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                           OtpVerificationScreen()));
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Send OTP",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Icon(Icons.send),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ));
          }));
        });
  }
}
