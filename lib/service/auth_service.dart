import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;

  Future signInAnon() async {
    try {
      final result = await firebaseAuth.signInAnonymously();
      if (kDebugMode) {
        print(result.user!.uid);
      }
      return result.user;
    } catch (e) {
      if (kDebugMode) {
        print("Anon error $e");
      }
    }
    return null;
  }

  Future<String?> forgotPassword(String email) async {
    String? res;
    try {
      final result = await firebaseAuth.sendPasswordResetEmail(email: email);
      if (kDebugMode) {
        //KDEBUGMODELER OLMASADA OLUR İFİN İÇİNDEKİ PRİNT YETER
        print("Mail kutunuzu kontrol ediniz");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        res = "Mail Zaten Kayitli.";
      }
      return res;
    }
    return null;
  }

  Future<String?> signIn(String email, String password) async {
    String? res;
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      res = 'Succsess';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          res = "Kullanici Bulunamadi";
          break;
        case "wrong-password":
          res = "Hatali Sifre";
          break;
        case "user-disabled":
          res = "Kullanici Pasif";
          break;
        default:
          res = "Bir Hata Ile Karsilasildi, Birazdan Tekrar Deneyiniz.";
          break;
      }
    }
    return res;
  }
}
