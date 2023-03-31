import 'package:flutter/material.dart';
import 'package:phone_number_verification/firebase_options.dart';
import 'package:phone_number_verification/provider/auth_provider.dart';
import 'package:phone_number_verification/screens/otp_verification_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phone_number_verification/screens/phone_number_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:
              // snapshot.hasdata
              //     ? const HomeScreen() :
              const PhoneNumberScreen()),
    );
  }
}
