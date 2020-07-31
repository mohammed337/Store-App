import 'package:flutter/material.dart';
import 'SplashScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      //remove banner from app
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }

}