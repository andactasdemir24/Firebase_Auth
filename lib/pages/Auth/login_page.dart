// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_entegrasyon/pages/home_page.dart';
import 'package:firebase_entegrasyon/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipPath(
          //appbarı oval şekle getirmek için kullandım altta da classdan cektim
          clipper: _CustomClipper(),
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Colors.green[600],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          //klavye açıldığında yer kaplama hatası almaması için
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tittleText(),
                const SizedBox(height: 30),
                emailTextField(), //Email
                const SizedBox(height: 20),
                passwordTextField(),
                const SizedBox(height: 20),
                forgotPasswordButton(),
                signInButton(), //Login
                const SizedBox(height: 20),
                signUpButton(),
                Center(
                  child: TextButton(
                      onPressed: () async {
                        final result = await authService.signInAnon();
                        Navigator.pushReplacementNamed(context, '/homePage');
                        if (null != result) {
                        } else {
                          if (kDebugMode) {
                            print('hata');
                          }
                        }
                      },
                      child: Text(
                        'Continue without registration',
                        style: TextStyle(color: Colors.grey[700]),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center tittleText() {
    return const Center(
      child: Text(
        'Login',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
      ),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Bilgileri eksiksiz doldurunuz';
        } else {}
        return null;
      },
      onSaved: (value) {
        email = value!;
      },
      style: const TextStyle(
        decoration: TextDecoration.underline,
        decorationThickness: 0, //yazdığımız yazının alt çizgisi olmaması
      ),
      cursorColor: Colors.green, //yazmak için tıkladığımızda yeşil yanıp sönen yer
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.next,
      decoration: customInputDecoration('Type your Email', const Icon(Icons.email_outlined)),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Bilgileri eksiksiz doldurunuz';
        } else {}
        return null;
      },
      onSaved: (value) {
        password = value!;
      },
      style: const TextStyle(
        decoration: TextDecoration.underline,
        decorationThickness: 0, //yazdığımız yerin al çizgisi
      ),
      cursorColor: Colors.green,
      keyboardType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      textInputAction: TextInputAction.next,
      obscureText: true, //şifrenin görünmez olması
      decoration: customInputDecoration('Type your Password', const Icon(Icons.password)),
    );
  }

  Align forgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
          onPressed: () {},
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.grey[700]),
          )),
    );
  }

  Center signInButton() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        height: 50,
        width: 1000,
        child: ElevatedButton(
          onPressed: signIn,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.green,
          ),
          child: const Text('LOGİN'),
        ),
      ),
    );
  }

  void signIn() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      final result = await authService.signIn(email, password);
      if (result == 'Succsess') {
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Hata'),
              content: Text(result!),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Geri Don"))],
            );
          },
        );
      }
    }
  }

  Center signUpButton() {
    return Center(
      child: TextButton(
          onPressed: () => Navigator.pushNamed(context, '/signup'),
          child: Text(
            'Create Account',
            style: TextStyle(color: Colors.grey[700]),
          )),
    );
  }

  InputDecoration customInputDecoration(String hintText, Icon icon) {
    return InputDecoration(
      prefixIcon: icon,
      iconColor: Colors.grey[600],
      prefixIconColor: Colors.grey[600],
      hintStyle: TextStyle(color: Colors.grey[600]),
      hintText: hintText,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  //Appbardaki ovalliği verdiğim yer
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
