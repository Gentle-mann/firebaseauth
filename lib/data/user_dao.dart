import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDao extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  bool isEmailVerified() {
    return auth.currentUser!.emailVerified;
  }

  String? getUserId() {
    return auth.currentUser?.uid;
  }

  String getEmail() {
    return auth.currentUser!.email!;
  }

  Future<String?> signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // TODO: Change this to showDialog
        log('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
      return e.message;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password is too weak');
      }
      return e.message;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> sendEmailVerification() async {
    try {
      await auth.currentUser?.sendEmailVerification();
      notifyListeners();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> sendPasswordResetLink(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      notifyListeners();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void logout() async {
    await auth.signOut();
    notifyListeners();
  }
}
