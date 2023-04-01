import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:phone_number_verification/controller/auth_controller.dart';
import 'package:phone_number_verification/firebase_options.dart';
import 'package:phone_number_verification/screens/otp_verification_screen.dart';
import 'package:phone_number_verification/screens/phone_number_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const PhoneNumberScreen());
  }
}
