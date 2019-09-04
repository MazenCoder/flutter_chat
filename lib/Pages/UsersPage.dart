import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/Pages/ChatPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'LoginPage.dart';

final Firestore _firestore = Firestore.instance;
FirebaseUser firebaseUser;

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        firebaseUser = user;
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
        appBar: AppBar(
          title: Text("All Users"),
          actions: <Widget>[
            new IconButton(icon: Icon(MdiIcons.logout), onPressed: () async {
              if(firebaseUser != null) {
                await _auth.signOut();
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },)
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: _firestore.collection("users").getDocuments(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.deepOrange,
                ),
              );
            }

            QuerySnapshot querySnapshot = snapshot.data;
            List<DocumentSnapshot> documents = querySnapshot.documents;
            return ListView.builder(
              itemCount: documents.length ?? 0,
              itemBuilder: (context, index) {
                return documents[index].data['email'] != firebaseUser.email ?
                  ListTile(
                  leading: CircleAvatar(),
                  title: Text('${documents[index].data['username']}'),
                  subtitle: Text('${documents[index].data['email']}'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ChatPage(documents[index].data['uid'])));
                  },
                  onLongPress: () {
                    print("${documents[index].data['uid']}");
                  },
                ) : Container();
              },
            );
          },
        ),
      ),
    );
  }
}
