import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fxchat/components/widgets.dart';
import 'package:fxchat/services/auth_service.dart';
import 'package:fxchat/services/db.dart';
import 'package:fxchat/services/state_manager.dart';
import 'package:fxchat/views/chat_room_screen.dart';

class SignIn extends StatefulWidget {
  final Function toggelView;
  SignIn({this.toggelView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  StateManager stateManager = StateManager();
  TextEditingController emailCtr = new TextEditingController();
  TextEditingController passwordCtr = new TextEditingController();
  bool isLoading = false;

  final DataBaseService dataBaseService = DataBaseService();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  void signIn() async {
    final AuthService authService = AuthService();
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      var result = await authService.signinWithEmailandPassowrd(
        emailCtr.text.trim(),
        passwordCtr.text.trim(),
      );

      if (result != null) {
        await stateManager.saveUserIsloggedin(true);
        QuerySnapshot snapshot =
            await dataBaseService.getUserByEmail(emailCtr.text.trim());

        await stateManager.saveUserEmail(emailCtr.text.trim());
        await stateManager
            .saveUserUserName(snapshot.documents.last.data['name']);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height - 100,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: emailCtr,
                              validator: (value) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)
                                    ? null
                                    : "Enter correct email";
                              },
                              decoration: textFieldDecoration("email"),
                              style: simpleTextStyle(),
                            ),
                            TextFormField(
                              controller: passwordCtr,
                              validator: (val) {
                                return val.length < 6
                                    ? "Enter Password 6+ characters"
                                    : null;
                              },
                              decoration: textFieldDecoration('password'),
                              style: simpleTextStyle(),
                            ),
                            SizedBox(height: 8),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              child: Text(
                                "Forgot Pasword ?",
                                style: simpleTextStyle(),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(colors: [
                              const Color(0xff007ef7),
                              const Color(0xff2a75bc),
                            ])),
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Text(
                        "Sign In with Google",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Dont have an account?",
                          style: mediumTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggelView();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Register now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
    );
  }
}
