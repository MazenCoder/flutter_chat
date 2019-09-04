import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Firestore _firestore = Firestore.instance;
FirebaseUser firebaseUser;

class ChatPage extends StatefulWidget {

  final String uid;
  ChatPage(this.uid);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final ScrollController listScrollController = new ScrollController();
  final TextEditingController _messageController = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormFieldState>();
  String groupChatId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if(user != null) {
        setState(() {
          firebaseUser = user;
          groupChatId = roomId(widget.uid, user.uid);
        });
        print(user.email);
      }
    }catch(e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        appBar: new AppBar(
          title: Text("Chat"),
        ),
          body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(groupChatId),
            new Divider(height: 1.0),
            Container(
              padding: EdgeInsets.only(left: 12, right: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      key: _formKey,
                      decoration: InputDecoration(
                        hintText: 'type your message'
                      ),
                      controller: _messageController,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if(_messageController.text.isNotEmpty) {
                        await _firestore.collection("chat")
                            .document(groupChatId)
                            .collection("messagem")
                            .add({
                              'text' : _messageController.text.trim(),
                              'sender' : firebaseUser.email,
                              'dateTime' : DateTime.now().toString(),
                              'uid' : widget.uid,
                            });
                        _messageController.clear();
                      }
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String roomId(String uid1, String uid2 ){
    String roomID;
    if(uid1.hashCode > uid2.hashCode){
      roomID = "$uid1$uid2";
    }else{
      roomID = "$uid2$uid1";
    }
    print("roomID: $roomID");
    return roomID;

  }
}

class MessageStream extends StatelessWidget {
  final String groupChatId;
  MessageStream(this.groupChatId);

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("chat")
          .document(groupChatId)
          .collection("messagem")
          .orderBy('dateTime', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.deepOrange,
            ),
          );
        }
        final messages = snapshot.data.documents;
        List<MessageBuilder> messageWidgets = [];
        for(var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final currentUser = firebaseUser.email;
          if(currentUser == messageSender) {

          }
          final messageBuilder = MessageBuilder(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageBuilder);
        }
        return Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }

}

class MessageBuilder extends StatelessWidget {

  final String sender;
  final String text;
  final bool isMe;
  MessageBuilder({this.sender, this.text, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text("${isMe ? "" : sender}", style: TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),),
          Material(
            borderRadius: isMe ? BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ) : BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            elevation: 5,
            color: isMe ? Colors.deepOrangeAccent : Colors.deepOrange.shade700,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text('$text',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
              ),),
            ),
          ),
        ],
      ),
    );
  }

}