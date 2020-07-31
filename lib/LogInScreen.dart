import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scarves_store/HomeScreen.dart';
import 'ForgotScreen.dart';
import 'SignUpScreen.dart';
class LogInScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LogInScreen();
  }

}

class _LogInScreen extends State<LogInScreen>{
  bool signInState = false;
  String email="",password="";
  var _formKey=GlobalKey<FormState>();


  final FirebaseAuth auth = FirebaseAuth.instance;



  Future<void> logIn() async {
try {
  await auth.signInWithEmailAndPassword(
      email: email.trim(), password: password.trim()).then((value) {
     Navigator.pushReplacement(context, MaterialPageRoute(
         builder: (BuildContext context) => HomeScreen(value.user.email)
     ));
  });
}catch(e){
  print("Error ${e.toString()}");
}

  }


  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<String> _GoogleSignIn() async{
    GoogleSignInAccount signInAccount=await _googleSignIn.signIn();
    GoogleSignInAuthentication signInAuthentication=await signInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(idToken: signInAuthentication.idToken, accessToken: signInAuthentication.accessToken);
    FirebaseUser user=(await auth.signInWithCredential(credential)).user;
    print(user);

    setState(() {
      signInState = true;
    });
    return user.email.toString();
  }



  @override
  void initState() {
    super.initState();
    Future(() async{
      if(await auth.currentUser()!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(auth.currentUser().toString())));
      }
    }

    );
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(

      backgroundColor: Color(0xff000725),
      //change column to listview
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 180,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    SizedBox(height: 50,),

                    Text("Log in",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                          fontSize: 45),
                    ),

                    Text("Welcom to our store",
                      style: TextStyle(color: Colors.white),)

                  ],
                ),
              ),

              decoration: BoxDecoration(borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(150)),
                color: Color(0xffff2fc3),
              ),

            ),

            Theme(
              data: ThemeData(
                  hintColor: Colors.blue
              ),
              child: Padding(padding: EdgeInsets.only(top: 50,right: 20,left: 20),
                child: TextFormField(
                  validator: (value){
                    if(value.isEmpty){
                      return "Please enter your email";
                    }else{
                      email=value;
                    }
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xffff2fc3),width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xffff2fc3),width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xffff2fc3),width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xffff2fc3),width: 1)
                    ),

                  ),
                ),
              ),
            ),


            Theme(
              data: ThemeData(
                  hintColor: Colors.blue
              ),
              child: Padding(padding: EdgeInsets.only(top: 10,right: 20,left: 20),
                child: TextFormField(
                  obscureText: true,
                  autocorrect: false,

                  validator: (value){
                    if(value.isEmpty){
                      return "Please enter your password";
                    }else{
                      password=value;
                    }
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xffff2fc3),width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xffff2fc3),width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xffff2fc3),width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xffff2fc3),width: 1)
                    ),

                  ),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.only(right: 20),
                child: Container(
                  width: double.infinity,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> ForgotScreen()));
                    },
                    child: Text("Forgot password ?",style: TextStyle(color: Color(0xffff2fc3)),
                      textAlign: TextAlign.right,),
                  ),
                )
            ),

            SizedBox(height: 20,),
            Padding(
                padding: EdgeInsets.only(left: 20,right: 20),
                child: RaisedButton(
                  onPressed: () {
                    if(_formKey.currentState.validate()){
                      logIn();
                    }

                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Color(0xffff2fc3),
                  child: Text("Log In",style: TextStyle(color: Colors.blue,
                      fontWeight: FontWeight.bold,fontSize: 20),),
                  padding: EdgeInsets.all(10),
                )
            ),

            SizedBox(height: 20),

            Container(
              width: double.infinity,
              height: 1,
              color: Colors.blue,
            ),

            Padding(padding: EdgeInsets.only(top: 20,left: 20,right: 20),
              child: RaisedButton(
                onPressed: (){
                  Future<String> user= _GoogleSignIn();
                  if(signInState){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>HomeScreen(user.toString())));
                  }
                },
                color: Colors.white,
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  children: <Widget>[
                    //we need to import font awesome
                    Icon(FontAwesomeIcons.google,color: Color(0xffff2fc3),),
                    SizedBox(width: 10,),
                    Text("Sign in with google",style: TextStyle(
                        fontSize: 20,color: Color(0xff000725)
                    ),)
                  ],
                ),

              ),
            ),

            Padding(padding: EdgeInsets.only(top: 5,left: 20,right: 20),
              child: RaisedButton(
                onPressed: (){},
                color: Colors.white,
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  children: <Widget>[
                    //we need to import font awesome
                    Icon(FontAwesomeIcons.facebook,color: Colors.blue,),
                    SizedBox(width: 10,),
                    Text("Sign in with facebook",style: TextStyle(
                        fontSize: 20,color: Color(0xff000725)
                    ),)
                  ],
                ),
              ),
            ),

            SizedBox(height: 20,),

            Center(
                child: Column(
                  children: <Widget>[
                    Text("Don't have an account ?",style: TextStyle(
                        color: Colors.white
                    ),),

                    FlatButton(onPressed: (){
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context)=> SignUpScreen())
                      );

                    },

                        child: Column(
                          children: <Widget>[
                            Text("Sign Up",style: TextStyle(color: Colors.blue),),

                            Container(
                              width: 45,
                              height: 1,
                              color: Colors.blue,
                            ),
                          ],
                        )


                    )


                  ],
                )

            )


          ],
        ),
      ),

    );
  }
}