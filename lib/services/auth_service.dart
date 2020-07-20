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
  User _userFormFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null ? new User(userId: firebaseUser.uid) : null;
  }

  //sigin anon
  Future signInAnon() async {
    try {
      AuthResult authResult = await _firebaseAuth.signInAnonymously();
      FirebaseUser firebaseUser = authResult.user;
      return _userFormFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future signinWithEmailandPassowrd(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser firebaseUser = authResult.user;
      return _userFormFirebaseUser(firebaseUser);
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
  Future signUpWithEmailandPassowrd(
      String email, String password, String userName) async {
    try {
      AuthResult authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;

      return _userFormFirebaseUser(firebaseUser);
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
