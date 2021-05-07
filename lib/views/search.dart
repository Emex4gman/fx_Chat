import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fxchat/components/widgets.dart';
import 'package:fxchat/services/db.dart';
import 'package:fxchat/services/state_manager.dart';
import 'package:fxchat/views/conversation_screen.dart';
// import 'package:fxchat/components/widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController sreachCtr = new TextEditingController();
  DataBaseService _dataBaseService = DataBaseService();
  // List searchResultlist = [];
  QuerySnapshot querySnapshot;
  void search() async {
    QuerySnapshot data = await _dataBaseService.getUserByUsername(sreachCtr.text.trim());
    setState(() {
      querySnapshot = data;
    });
    // print(datd.documents[0].data);
  }

  Widget searchResultlist() {
    return querySnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                email: querySnapshot.docs[index].data(),
                userName: querySnapshot.docs[index].data(),
              );
            },
          )
        : Container();
  }

  createChatroom(String username, String myName) async {
    String chatRoomId = '${username}_$myName';
    List<String> users = [username, myName];
    Map<String, dynamic> chatRoomMap = {'users': users, "chatroomId": chatRoomId};
    await _dataBaseService.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => ConversationScreen(
                  chatRoomId: chatRoomId,
                )));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: Color(0x54ffffff)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextFormField(
                    controller: sreachCtr,
                    decoration: InputDecoration(hintText: "enter username", focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none), enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none), hintStyle: TextStyle(color: Colors.white54)),
                    style: simpleTextStyle(),
                  )),
                  GestureDetector(
                    onTap: () {
                      search();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36ffffff),
                            const Color(0x0fffffff),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchResultlist(),
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String email;
  SearchTile({this.userName = "", this.email = ""});
  final DataBaseService _dataBaseService = DataBaseService();

  createChatroom({BuildContext context, String userName, String myName}) async {
    String chatRoomId = '${userName}_$myName';
    if (myName != userName) {
      List<String> users = [userName, myName];
      Map<String, dynamic> chatRoomMap = {'users': users, "chatroomId": chatRoomId};
      _dataBaseService.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => ConversationScreen(
                    chatRoomId: chatRoomId,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userName,
                  style: mediumTextStyle(),
                ),
                SizedBox(height: 10),
                Text(
                  email,
                  style: simpleTextStyle(),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                String myName = await StateManager().getUserUserName();
                createChatroom(context: context, myName: myName, userName: userName);
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .3,
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
                  'Message',
                  style: simpleTextStyle(),
                ),
              ),
            )
          ],
        ));
  }
}
