import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scarves_store/LogInScreen.dart';
import 'Data.dart';
import 'LogInScreen.dart';
import 'UploadData.dart';
import 'MyFavorite.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String currentEmail;

  HomeScreen(this.currentEmail);

  @override
  _HomeScreenState createState() => _HomeScreenState(currentEmail);
}

class _HomeScreenState extends State<HomeScreen> {
  String currentEmail;
  List<Data> dataList = [];
  List<bool> favList = [];
  bool searchState = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  _HomeScreenState(this.currentEmail);



  Future<void> logOut() async {
    auth.signOut().then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => LogInScreen()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference referenceData = FirebaseDatabase.instance.reference().child("Data");
    referenceData.once().then((DataSnapshot dataSnapShot) {
      dataList.clear();
      favList.clear();

      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {

        Data data = new Data(
            values [key]['imgUrl'],
            values [key]['name'],
            values [key]['material'],
            values [key]['price'],
            key
            //key is the uploadid
        );
        dataList.add(data);
        auth.currentUser().then((value) {
          DatabaseReference reference = FirebaseDatabase.instance.reference().child("Data").child(key).child("Fav")
              .child(value.uid).child("state");
          reference.once().then((DataSnapshot snapShot){
            if(snapShot.value!=null){
              if(snapShot.value=="true"){
                favList.add(true);
              }else{
                favList.add(false);
              }
            }else{
              favList.add(false);
            }
            });
        });

      }


      Timer(Duration(seconds: 1),(){
        setState(() {
          //
        });
      });


    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xffff2fc3),
        title: !searchState?Text("Home"):
                            TextField(
                              decoration: InputDecoration(
                                  icon: Icon(Icons.search),
                                  hintText: "Search ...",
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              onChanged: (text){
                                SearchMethod(text);
                              },
                            ),
        actions: <Widget>[
          !searchState?IconButton(icon: Icon(Icons.search,color: Colors.white,), onPressed: (){
            setState(() {
              searchState = !searchState;
            });
          }
          ):
          IconButton(icon: Icon(Icons.cancel,color: Colors.white,), onPressed: (){
            setState(() {
              searchState = !searchState;
            });
          }
          ),

          FlatButton.icon(
              onPressed: () {
                logOut();
              },
              icon: Icon(Icons.person),
              label: Text("Log out"))
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 170,
              color: Color(0xff000725),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Image(image: AssetImage("images/sslogo.png"),
                    height: 90,
                    width: 90,),
                  SizedBox(height: 10,),
                  Text(currentEmail, style: TextStyle(color: Colors.white),)
                ],
              ),
            ),
            ListTile(
              title: Text("Upload"),
              leading: Icon(Icons.cloud_upload),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context) => UploadData()));
              },
            ),

            ListTile(
              title: Text("My Favorite"),
              leading: Icon(Icons.favorite),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyFavorite()));
              },
            ),

            ListTile(
              title: Text("My Profile"),
              leading: Icon(Icons.person),
            ),
            Divider(),

            ListTile(
              title: Text("Contact US"),
              leading: Icon(Icons.email),
            ) //line
          ],
        ),
      ),
      body: dataList.length == 0
          ? Center(
          child: Text("No Data Available", style: TextStyle(fontSize: 30),))
          : ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (_, index) {
            return CardUI(dataList[index].imgUrl, dataList[index].name,
                dataList[index].material, dataList[index].price,dataList[index].uploadid,index);
          }
      ),
    );
  }

  Widget CardUI(String imgUrl, String name, String material, String price,String uploadId,int index) {
    return Card(
      elevation: 7,
      margin: EdgeInsets.all(15),
      color: Color(0xffff2fc3),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(1.5),
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Image.network(imgUrl, fit: BoxFit.cover, height: 100,),
            SizedBox(height: 1,),
            Text(name, style: TextStyle(color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold),),
            SizedBox(height: 1,),
            Text("material:- $material"),
            SizedBox(height: 1,),
            Container(
              width: double.infinity,
              child: Text(price, style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,),
            ),
            SizedBox(height: 1,),

            favList[index]?
    IconButton(icon: Icon(Icons.favorite,color: Colors.red,), onPressed: () {
      auth.currentUser().then((value) {
        DatabaseReference favRef = FirebaseDatabase.instance.reference().child(
            "Data").child(uploadId).child("Fav")
            .child(value.uid).child("state");
        favRef.set("false");
        setState(() {
          FavoriteFunc();
        });
      });
    }):
            IconButton(icon: Icon(Icons.favorite_border), onPressed: (){
              auth.currentUser().then((value) {
                DatabaseReference favRef = FirebaseDatabase.instance.reference().child("Data").child(uploadId).child("Fav")
                    .child(value.uid).child("state");
                favRef.set("true");

                setState(() {
                  FavoriteFunc();
                });

              });


            })

          ],
        ),
      ),
    );
  }

  void FavoriteFunc() {
    DatabaseReference referenceData = FirebaseDatabase.instance.reference()
        .child("Data");
    referenceData.once().then((DataSnapshot dataSnapShot) {
      favList.clear();

      var keys = dataSnapShot.value.keys;

      for (var key in keys) {
        auth.currentUser().then((value) {
          DatabaseReference reference = FirebaseDatabase.instance.reference()
              .child("Data").child(key).child("Fav")
              .child(value.uid)
              .child("state");
          reference.once().then((DataSnapshot snapShot) {
            if (snapShot.value != null) {
              if (snapShot.value == "true") {
                favList.add(true);
              } else {
                favList.add(false);
              }
            } else {
              favList.add(false);
            }
          });
        });
      }
      Timer(Duration(seconds: 1), (){
        setState(() {
          //
        });
      });

    });
  }

  void SearchMethod(String text) {
    DatabaseReference searchRef = FirebaseDatabase.instance.reference().child("Data");
    searchRef.once().then((DataSnapshot snapShot){
      dataList.clear();
      var keys = snapShot.value.keys;
      var values = snapShot.value;

      for(var key in keys){
        Data data = new Data(
            values [key]['imgUrl'],
            values [key]['name'],
            values [key]['material'],
            values [key]['price'],
            key
          //key is the uploadid
        );
        if(data.name.contains(text)){
          dataList.add(data);
        }
      }
      Timer(Duration(seconds: 1),(){
        setState(() {
          //
        });
      });
    });
  }

}