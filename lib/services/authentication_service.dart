import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jungle/screens/splash/sign_in_num_verify.dart';
import 'package:jungle/services/auth_exception_handler.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);
  AuthResultStatus _status;

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
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleException(e);
    }
    return AuthResultStatus.successful ;
  }

  Future<void> deleteCurrentUser() async {
    try {
      await _firebaseAuth.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  void clearStatus() {
    _status = null;
    notifyListeners();
  }
}
