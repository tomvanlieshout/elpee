import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<bool> isAuthenticated();

  Future<void> signOut();

  Future<void> changePassword(String currentPassword, String newPassword);

  Future<String> deleteAccount(String password);

  Future<bool> isEmailVerified();

  Future forgotPassword(String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult result;
    try {
      result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      FirebaseUser user = result.user;
      return user;
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      return user;
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future<FirebaseUser> getCurrentUser() async => await _firebaseAuth.currentUser();

  Future<bool> isAuthenticated() async => await _firebaseAuth.currentUser() != null;

  Future<void> signOut() async => _firebaseAuth.signOut();

  Future<String> deleteAccount(String password) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    AuthCredential credential = EmailAuthProvider.getCredential(email: user.email, password: password);
    AuthResult result = await user.reauthenticateWithCredential(credential);
    if (result.user != null) {
      String path = 'users/${user.uid}';
      var json = jsonEncode({
        'data': {'path': path}
      });
      final headers = {
        'Content-Type': 'application/json',
      };
      try {
        await post('https://europe-west3-elpee-61c3f.cloudfunctions.net/deleteAccount', headers: headers, body: json);
        user.delete();
        return 'Account was deleted successfully.';
      } on PlatformException catch (e) {
        throw e;
      }
    }
    return '';
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    AuthCredential credential = EmailAuthProvider.getCredential(email: user.email, password: currentPassword);
    AuthResult result = await user.reauthenticateWithCredential(credential);
    if (result.user != null) {
      try {
        user.updatePassword(newPassword);
      } on PlatformException catch (e) {
        throw e;
      }
    }
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future forgotPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
