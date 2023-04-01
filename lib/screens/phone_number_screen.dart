import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:phone_number_verification/controller/auth_controller.dart';

import '../keys.dart';
import 'otp_verification_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  String _selectedCountryCode = '+91';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
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
                      Row(children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: 60,
                            height: 58,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5)),
                            child: CountryCodePicker(
                              initialSelection: 'IN',
                              alignLeft: true,
                              favorite: const ['+91', 'IN'],
                              onChanged: (countryCode) {
                                setState(() {
                                  _selectedCountryCode = countryCode.toString();
                                  AuthController.instance.countryCodeController
                                      .text = _selectedCountryCode;
                                });
                              },
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller:
                                AuthController.instance.phoneNumberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              } else if (value.length != 10) {
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
                        ),
                      ]),
                      const SizedBox(
                        height: 30,
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
                                AuthController.instance
                                    .verifyPhoneNumber(context);
                                Get.to(() => const OtpVerificationScreen());
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
                ))));
  }
}
