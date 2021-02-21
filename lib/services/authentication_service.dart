import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/material.dart';
import 'package:jungle/screens/splash/sign_in_num_verify.dart';
import 'package:jungle/services/auth_exception_handler.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);
  AuthResultStatus _status;
  PhoneAuthCredential credential;

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();
  AuthResultStatus get status => _status;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> verifyNumber({String number, BuildContext context}) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+1' + number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          //Android
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          this._status = AuthExceptionHandler.handleException(e);
          notifyListeners();
        },
        codeSent: (String verificationId, int resendToken) async {
          this.clearStatus();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignInNumVerify(
                      number: number,
                      vid: verificationId,
                      resendToken: resendToken)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: Duration(seconds: 120));
  }

  Future<AuthResultStatus> signInWithPhoneCred(
      {String verificationId, String smsCode}) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      credential = phoneAuthCredential;
      notifyListeners();
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
    } catch (e) {
      return AuthExceptionHandler.handleException(e);
    }
    return AuthResultStatus.successful;
  }

  Future<void> deleteCurrentUser() async {
    try {
      if (credential != null)
        await _firebaseAuth.currentUser
            .reauthenticateWithCredential(credential);
      await _firebaseAuth.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  void clearStatus() {
    _status = null;
    notifyListeners();
  }
}
