import 'package:firebase_auth/firebase_auth.dart';
import 'package:fxchat/model/user_model.dart';

abstract class BaseAuth {
  signInAnon();
  signinWithEmailandPassowrd(String email, String password);
  signUpWithEmailandPassowrd(String email, String password, String userName);
  signUpWithGoogle();
  resetPassword(String email);
  signout();
}

class AuthService implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _userFormFirebaseUser(UserCredential firebaseUser) {
    return firebaseUser.user ;
  }

  //sigin anon
  Future signInAnon() async {
    try {
      UserCredential authResult = await _firebaseAuth.signInAnonymously();
      User firebaseUser = authResult.user;
      return _userFormFirebaseUser(authResult);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future signinWithEmailandPassowrd(String email, String password) async {
    try {
      UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      User firebaseUser = authResult.user;
      return _userFormFirebaseUser(authResult);
    } catch (e) {
      print(e);
    }
  }

  @override
  signUpWithGoogle() {}
  @override
  //sign out
  Future signout() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future signUpWithEmailandPassowrd(String email, String password, String userName) async {
    try {
      UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = authResult.user;

      return _userFormFirebaseUser(authResult);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  resetPassword(String email) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
