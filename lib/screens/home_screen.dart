import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number_verification/controller/auth_controller.dart';
import 'package:phone_number_verification/screens/phone_number_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userNumber = AuthController.instance.countryCodeController.text +
      AuthController.instance.phoneNumberController.text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onPressed: () {
              AuthController.instance.signOut();
              Get.to(() => const PhoneNumberScreen());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HELLO!",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
              Text("${AuthController.instance.userNumber}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,),)
              ],
        ),
      ),
    );
  }
}
