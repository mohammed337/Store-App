
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'LogInScreen.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreen();
  }

}

class _SplashScreen extends State<SplashScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff000725),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyImage(),
                    Text("Scarves Store",style: TextStyle(fontSize: 35
                        ,fontStyle: FontStyle.italic,color: Color(0xffff2fc3)),
                    )
                  ],
                )
            ),

            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 20,),
                    Text("Online store for everyone"
                      ,style: TextStyle(
                          fontStyle: FontStyle.italic
                          ,fontSize: 18
                          ,color: Color(0xffffffff)),)
                  ],
                )
            ),
          ],
        ),
      ),

    );
  }
  FirebaseAuth auth =FirebaseAuth.instance;
//first we need to navigate to log in screen
  void NavigateToLogIn(){
    Timer(Duration(seconds: 5), () async {
      if(await auth.currentUser()==null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (BuildContext context) => LogInScreen()));
      }else{
        currentEmail();

      }
    });

  }

  @override
  void initState() {
    super.initState();
    NavigateToLogIn();
  }

  Future<void> currentEmail() async {
    await auth.currentUser().then((value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(value.email)));
    });
  }

}

class MyImage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    AssetImage image=new AssetImage("images/sslogo.png");
    Image logo=new Image(image: image,width: 90,height: 90,);
    return logo;
  }
}