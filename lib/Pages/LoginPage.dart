import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ChatPage.dart';
import 'UsersPage.dart';

final Firestore _firestore = Firestore.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  FirebaseUser firebaseUser;
  SharedPreferences prefs;


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
      prefs = await SharedPreferences.getInstance();
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
        body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Image.asset('assets/images/Adria-logo.png', width: 200,),
                    new SizedBox(height: 35,),
                    new TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Entrer email',
                        icon: new Icon(Icons.email),
                      ),
                      validator: (val) {
                        if(val.isEmpty)
                          return "Champs obligatoire";
                        return null;
                      },
                    ),
                    new SizedBox(height: 8,),
                    new TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Entrer mot de pass',
                        icon: new Icon(Icons.lock),
                      ),
                      validator: (val) {
                        if(val.isEmpty)
                          return "Champs obligatoire";
                        return null;
                      },
                    ),
                    new SizedBox(height: 18,),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new OutlineButton(
                          splashColor: Colors.indigo,
                          textColor: Colors.indigo,
                          onPressed: () async {
                            if(_formKey.currentState.validate()) {
                              if(firebaseUser == null) {
                                AuthResult auth = await _auth.signInWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                                if(auth != null) {
                                  _firestore.collection('users').document(auth.user.uid).setData({
                                    'email' : auth.user.email,
                                    'uid' : auth.user.uid,
                                    'username' : auth.user.displayName ?? 'user'
                                  }).whenComplete(() {
                                    prefs.setString('id', auth.user.uid);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UsersPage()));
                                  });
                                }
                              }else {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => UsersPage()));
                              }
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          highlightElevation: 2,
                          borderSide: BorderSide(color: Colors.indigo),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                new Icon(MdiIcons.login),
                              ],
                            ),
                          ),
                        ),
                        new OutlineButton(
                          splashColor: Colors.indigo,
                          textColor: Colors.indigo,
                          onPressed: () async {
                            if(_formKey.currentState.validate()) {
                              if(firebaseUser == null) {
                                AuthResult auth = await _auth.createUserWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                                if(auth != null) {
                                  _firestore.collection('users').document(auth.user.uid).setData({
                                    'email' : auth.user.email,
                                    'uid' : auth.user.uid,
                                    'username' : auth.user.displayName ?? 'user'
                                  }).whenComplete(() {
                                    prefs.setString('id', auth.user.uid);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UsersPage()));
                                  });
                                }
                              }else {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => UsersPage()));
                              }
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          highlightElevation: 2,
                          borderSide: BorderSide(color: Colors.indigo),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                new Icon(MdiIcons.loginVariant),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    new SizedBox(height: 30,),
                    new OutlineButton(
                      splashColor: Colors.red,
                      textColor: Colors.red,
                      onPressed: () async {
                        FirebaseUser user = await _handleSignIn();
                        if(user != null) {
                          print(user.email);
                          print(user.displayName);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => UsersPage()));
                        }
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      highlightElevation: 2,
                      borderSide: BorderSide(color: Colors.red),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                'Sign In with Google',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            new Icon(MdiIcons.google),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}
