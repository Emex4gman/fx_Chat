import 'package:flutter/material.dart';
import 'package:fxchat/components/widgets.dart';
import 'package:fxchat/services/db.dart';
import 'package:fxchat/services/state_manager.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen({this.chatRoomId});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageCtr = new TextEditingController();
  DataBaseService dataBaseService = new DataBaseService();
  ScrollController chatScrollController = new ScrollController();
  Stream chatMessageStream;

  @override
  void initState() {
    super.initState();
    getConversation();
  }

  getConversation() async {
    setState(() {
      chatMessageStream =
          dataBaseService.getConversationMessages(widget.chatRoomId);
    });
  }

  Widget chatList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapShot) {
          return snapShot.hasData
              ? ListView.builder(
                  controller: chatScrollController,
                  // reverse: true,
                  shrinkWrap: true,
                  itemCount: snapShot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      message: snapShot.data.documents[index].data['message'],
                      isSentByMe:
                          snapShot.data.documents[index].data['sentBy'] ==
                                  StateManager().myname
                              ? true
                              : false,
                    );
                  },
                )
              : Container();
        });
  }

  sendMessage() async {
    String myName = await StateManager().getUserUserName();
    if (messageCtr.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "message": messageCtr.text.trim(),
        "sentBy": myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      await dataBaseService.sendConversationMessage(widget.chatRoomId, message);
      setState(() {
        messageCtr.text = "";
      });
      scrollToBottom();
    } else {
      print('cannot be emoty');
    }
  }

  scrollToBottom() {
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent +
          MediaQuery.of(context).viewInsets.bottom,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0.0) {
      scrollToBottom();
    }
    return Scaffold(
      appBar: appBarMain(context),
      body: Column(
        children: <Widget>[
          Expanded(child: chatList()),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: Color(0x54ffffff)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextFormField(
                    controller: messageCtr,
                    decoration: InputDecoration(
                        hintText: "message...",
                        focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        hintStyle: TextStyle(color: Colors.white54)),
                    style: simpleTextStyle(),
                  )),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
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
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile({this.message, this.isSentByMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: MediaQuery.of(context).size.width,
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSentByMe
                ? LinearGradient(colors: [
                    const Color(0xff007ef7),
                    const Color(0xff2a75bc),
                  ])
                : LinearGradient(colors: [
                    const Color(0x36ffffff),
                    const Color(0x0fffffff),
                  ]),
            borderRadius: isSentByMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
                : BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
          ),
          child: Text(message,
              style: TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
  }
}
