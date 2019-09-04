import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/Pages/LoginPage.dart';
import 'package:flutter_chat/Pages/UsersPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: FutureBuilder<FirebaseUser>(
        future: _auth.currentUser(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return SplashScreen(
                seconds: 1,
                navigateAfterSeconds: new UsersPage(),
                image: new Image.asset('assets/images/Adria-logo.png'),
                backgroundColor: Colors.white,
                styleTextUnderTheLoader: new TextStyle(),
                photoSize: 100.0,
                loaderColor: Colors.red
            );
          }
          return SplashScreen(
              seconds: 1,
              navigateAfterSeconds: new LoginPage(),
              image: new Image.asset('assets/images/Adria-logo.png'),
              backgroundColor: Colors.white,
              styleTextUnderTheLoader: new TextStyle(),
              photoSize: 100.0,
              loaderColor: Colors.red
          );
        },
      ),
    );
  }
}

