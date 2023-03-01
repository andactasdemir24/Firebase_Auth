import 'package:firebase_entegrasyon/pages/Auth/login_page.dart';
import 'package:firebase_entegrasyon/pages/Auth/sign.up.dart';
import 'package:firebase_entegrasyon/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/loginPage': (context) => const LoginPage(),
          '/signup': (context) => const SignUp(),
          '/homePage': (context) => const HomePage(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage());
  }
}
