import 'package:flutter/material.dart';
import 'UserAcc.dart';
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Login.dart';

class Page2 extends StatefulWidget {
  static String tag = 'page2';
  String title;
  final String cityName;
  final String type;
  Page2({Key key, @required this.cityName, @required this.type}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new Page2State();
  }
}

class Page2State extends State<Page2> {
  String token;
  BuildContext scaffoldContext;
  UserAcc userAcc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    fetchAccount();
  }
  @override
  Widget build(BuildContext context) {

    var breakfastButton  = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {

          },
          color: Colors.lightBlueAccent,
          child: Text('Breakfast ', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    var lunchButton  = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {

          },
          color: Colors.lightBlueAccent,
          child: Text('Lunch ', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    var dinnerButton  = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {

          },
          color: Colors.lightBlueAccent,
          child: Text('Dinner ', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    return new Scaffold(
        appBar: new AppBar(
          // here we display the title corresponding to the fragment
          // you can instead choose to have a static title
          title: new Text('Page 2'),
          elevation: 0,
          centerTitle: false,

        ),

        body: new Builder(builder: (BuildContext context)
        {
          scaffoldContext = context;
          return new Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                breakfastButton,
                lunchButton,
                dinnerButton
              ],
            ),
          );
        }));
  }
}