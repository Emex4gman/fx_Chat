import 'package:flutter/material.dart';
import 'package:fxchat/components/widgets.dart';
import 'package:fxchat/services/auth_service.dart';
import 'package:fxchat/services/db.dart';
import 'package:fxchat/services/state_manager.dart';
import 'package:fxchat/views/chat_room_screen.dart';

class SignUp extends StatefulWidget {
  final Function toggelView;
  SignUp({this.toggelView});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  TextEditingController usernameCtr = new TextEditingController();
  TextEditingController emailCtr = new TextEditingController();
  TextEditingController passwordCtr = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  StateManager stateManager = StateManager();
  @override
  void initState() {
    super.initState();
  }

  void signUp() async {
    final AuthService authService = AuthService();
    DataBaseService _dataBaseService = new DataBaseService();

    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      var result = await authService.signUpWithEmailandPassowrd(
          emailCtr.text.trim(),
          passwordCtr.text.trim(),
          usernameCtr.text.trim());
      if (result != null) {
        Map<String, dynamic> userInfoMap = {
          "email": emailCtr.text.trim(),
          "name": usernameCtr.text.trim(),
        };
        await stateManager.saveUserIsloggedin(true);
        await stateManager.saveUserEmail(emailCtr.text.trim());
        await stateManager.saveUserUserName(usernameCtr.text.trim());

        _dataBaseService.uploadUserInfo(userInfoMap);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  String _validator(String value) {
    return value.isEmpty || value.length < 4
        ? 'cannot be empty or less than 4'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
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
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (value) {
                              return _validator(value);
                            },
                            controller: usernameCtr,
                            decoration: textFieldDecoration("username"),
                            style: simpleTextStyle(),
                          ),
                          TextFormField(
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)
                                  ? null
                                  : "Enter correct email";
                            },
                            controller: emailCtr,
                            decoration: textFieldDecoration("email"),
                            style: simpleTextStyle(),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.length < 6
                                  ? "Enter Password 6+ characters"
                                  : null;
                            },
                            controller: passwordCtr,
                            decoration: textFieldDecoration('password'),
                            style: simpleTextStyle(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerRight,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: Text(
                        "Forgot Pasword ?",
                        style: simpleTextStyle(),
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        signUp();
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
                          "Sign Up",
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
                        "Sign Up with Google",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account?",
                          style: mediumTextStyle(),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            widget.toggelView();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Sing In now",
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
