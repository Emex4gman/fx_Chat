import 'package:flutter/material.dart';
import 'package:fxchat/helper/authenticate.dart';
import 'package:fxchat/services/state_manager.dart';
import 'package:fxchat/views/chat_room_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  StateManager stateManager = StateManager();
  void initApp() {
    Future.delayed(Duration(seconds: 4), () async {
      var result = await stateManager.getUserIsloggedin();
      if (result == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (cxt) => ChatRoom()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (cxt) => Authenticate()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xff007ef7),
                      const Color(0xff2a75bc),
                    ]),
                    borderRadius: BorderRadius.circular(150)),
                child: Center(
                  child: Text(
                    'FX_CHAT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
