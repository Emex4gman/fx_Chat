import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fxchat/components/widgets.dart';
import 'package:fxchat/helper/authenticate.dart';
import 'package:fxchat/services/auth_service.dart';
import 'package:fxchat/services/db.dart';
import 'package:fxchat/services/state_manager.dart';
import 'package:fxchat/views/conversation_screen.dart';
import 'package:fxchat/views/search.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key key}) : super(key: key);
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  StateManager stateManager = StateManager();
  DataBaseService dataBaseService = DataBaseService();
  Stream<QuerySnapshot> userChatRoomStream;
  loadChatRoom() async {
    String userName = await stateManager.getUserUserName();
    userChatRoomStream = dataBaseService.getchatRoomsByUser(userName);
    setState(() {});
  }

  void signOut() async {
    final AuthService authService = AuthService();
    await stateManager.saveUserIsloggedin(false);
    await authService.signout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
  }

  Widget chatRoomList() {
    return StreamBuilder<QuerySnapshot>(
        stream: userChatRoomStream,
        builder: (contex, snapShot) {
          return snapShot.hasData
              ? ListView.builder(
                  itemCount: snapShot.data.docs.length,
                  itemBuilder: (contex, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (contex) => ConversationScreen(
                              chatRoomId: snapShot.data.docs[index].get("name"),
                            ),
                          ),
                        );
                      },
                      child: ChatRoomTile(
                        otherUsername: snapShot.data.docs[index].get('chatroomId').toString().replaceAll('_', "").replaceAll(stateManager.myname, ''),
                      ),
                    );
                  },
                )
              : Container();
        });
  }

  @override
  void initState() {
    super.initState();
    loadChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FX_CHAT'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                signOut();
              })
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (cxt) => SearchScreen()));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String otherUsername;
  ChatRoomTile({this.otherUsername});
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.black,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: <Widget>[
            Container(
                height: 60,
                width: 60,
                child: Center(
                  child: Text(
                    'T',
                    style: mediumTextStyle(),
                  ),
                ),
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(60))),
            SizedBox(width: 8),
            Text(
              '$otherUsername',
              style: mediumTextStyle(),
            ),
          ],
        ));
  }
}
