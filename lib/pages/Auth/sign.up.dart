import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email, fullname, username, password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
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
                emailTextField(),
                const SizedBox(height: 20),
                fullnameTextField(),
                const SizedBox(height: 20),
                usernameTextField(), //Email
                const SizedBox(height: 20),
                passwordTextField(),
                const SizedBox(height: 50),
                signUpButton(),
                backToLoginPage(),
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

  TextFormField fullnameTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Bilgileri eksiksiz doldurunuz';
        } else {}
        return null;
      },
      onSaved: (value) {
        fullname = value!;
      },
      style: const TextStyle(
        decoration: TextDecoration.underline,
        decorationThickness: 0, //yazdığımız yerin al çizgisi
      ),
      cursorColor: Colors.green,
      textInputAction: TextInputAction.next,
      decoration: customInputDecoration('Type your Fullname', const Icon(Icons.person_add_alt_1_outlined)),
    );
  }

  TextFormField usernameTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Bilgileri eksiksiz doldurunuz';
        } else {}
        return null;
      },
      onSaved: (value) {
        username = value!;
      },
      style: const TextStyle(
        decoration: TextDecoration.underline,
        decorationThickness: 0, //yazdığımız yerin al çizgisi
      ),
      cursorColor: Colors.green,
      textInputAction: TextInputAction.next,
      decoration: customInputDecoration('Type your Username', const Icon(Icons.person_pin_outlined)),
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

  Center backToLoginPage() {
    return Center(
      child: TextButton(
          onPressed: () => Navigator.pushNamed(context, '/loginPage'),
          child: Text(
            'LOGİN PAGE',
            style: TextStyle(color: Colors.grey[700]),
          )),
    );
  }

  Center signUpButton() {
    return Center(
      child: TextButton(
          onPressed: () async {
            if (formkey.currentState!.validate()) {
              formkey.currentState!.save();
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signing up was successful. You are redirected to the login page.')));
                Navigator.popAndPushNamed(context, '/loginPage');
                // ignore: unused_local_variable
                var userResult = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
                formkey.currentState!.reset();
              } catch (e) {
                if (kDebugMode) {
                  print(e.toString());
                }
              }
            } else {}
          },
          child: Text(
            'Sign Up',
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
