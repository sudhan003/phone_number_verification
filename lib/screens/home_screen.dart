import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_number_verification/provider/auth_provider.dart';
import 'package:phone_number_verification/screens/otp_verification_screen.dart';
import 'package:phone_number_verification/screens/phone_number_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    getUserPhoneNumber();
  }

  Future<void> getUserPhoneNumber() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.phoneNumber != null) {
      setState(() {
        phoneNumber = user.phoneNumber!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              model.signOut();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>  OtpVerificationScreen()));
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onPressed: () {
                model.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PhoneNumberScreen()));
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              phoneNumber == null
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Hello!",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 40),
                    ),
              Text(
                " $phoneNumber",
                style: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
      );
    });
  }
}
