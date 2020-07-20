import 'package:flutter/material.dart';
import 'package:fxchat/views/signin_screen.dart';
import 'package:fxchat/views/signup_screen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSigIn = true;

  void toggleView() {
    setState(() {
      showSigIn = !showSigIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSigIn
        ? SignIn(toggelView: toggleView)
        : SignUp(toggelView: toggleView);
  }
}
