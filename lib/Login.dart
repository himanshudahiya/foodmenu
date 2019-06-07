import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'Register.dart';
import 'Dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'UserAuth.dart';
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  BuildContext scaffoldContext;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String url = config().serverAdd+"/user/login";
  // make post request for login
  Future<UserAuth> UserLogin(String email, String password) async {
//    var reqBody;
//    if(validateEmail(email)) {
//      reqBody = {
//        "email": email,
//        "password": password
//      };
//    }
//    else{
//      Navigator.of(context).pop();
//      _showToast("Enter Valid Email");
//      return UserAuth();
//    }
//    String jsonParam = json.encode(reqBody);
//    final response = await http.post(url,
//      headers: {
//        "Accept": "application/json",
//        "Content-Type": "application/json; charset=UTF-8"
//      },
//      body: jsonParam,
//    );
//
//    var responseJson = json.decode(response.body.toString());
//    UserAuth userAuth = createUserList(responseJson);
//    if(userAuth.isAuth){
//      _authDetails(userAuth.token, userAuth.isAuth);
//      Navigator.of(context).pop();
//      Navigator.of(context).pushReplacementNamed(HomePage.tag);
//    }
//    else {
//      Navigator.of(context).pop();
//      _showToast(userAuth.error);
//    }
//    return userAuth;
    Navigator.of(context).pushReplacementNamed(HomePage.tag);

  }

  // get token and auth status from request response
  UserAuth createUserList(var data){
    var error = data["error"];
    String token;
    bool auth;
    if(error==null) {
      token = data["token"];
      auth = data["auth"];
    }
    else{
      auth = false;
      token = null;
    }
    UserAuth userAuth = new UserAuth(token: token,isAuth: auth, error: error);
    return userAuth;
  }

  // show toast on failed request
  void _showToast(String error) {
    final scaffold = Scaffold.of(scaffoldContext);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text(error),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  // email validation
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  // mobile validation


  _authDetails(String token, bool isAuth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuth', isAuth);
    await prefs.setString('token', token);
    print(prefs.getBool('isAuth'));
  }



  @override
  Widget build(BuildContext context) {


    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            var emailVal = emailController.text;
            var passVal = passwordController.text;
            showDemoDialog<int>(dismissable: false,
                context: context,
                child: progressLoader
            );
            UserLogin(emailVal, passVal);
          },
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );


    final alternativeLine = Text(
      '-----OR-----', textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey,
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            Navigator.of(context).pushNamed(RegisterPage.tag);
          },
          color: Colors.lightBlueAccent,
          child: Text('Register', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: new Builder(builder: (BuildContext context) {
          scaffoldContext = context;
          return new Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton,
                SizedBox(height: 24.0),
                alternativeLine,
                SizedBox(height: 20.0),
                registerButton
              ],
            ),
          );
        }));
  }
}