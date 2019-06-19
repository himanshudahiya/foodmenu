import 'package:flutter/material.dart';
import 'Login.dart';
import 'Homepage.dart';
import 'Register.dart';
import 'Page2.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'foodMenu';
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    RegisterPage.tag: (context) => RegisterPage(),
    Page2.tag: (context) => Page2(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      routes: routes,
      theme: ThemeData(fontFamily: 'Roboto', primaryColor: Colors.white,),
      //home: HomePage(title: appTitle),
    );
  }

}


