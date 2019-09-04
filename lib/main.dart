import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Pages/SplashPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
//      theme: ThemeData.light().copyWith(
//        textTheme: TextTheme(
//          body1: TextStyle(color: Colors.deepOrangeAccent),
//        ),
//      ),
      home: SplashPage(),
    );
  }
}