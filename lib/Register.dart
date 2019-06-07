import 'package:flutter/material.dart';
import 'Login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'UserAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'Dialog.dart';
import 'Homepage.dart';
class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  BuildContext scaffoldContext;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    userNameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }
  Future<void> UserRegister(String username,String email, String mobile, String password) async {
    var reqBody;
    String url = config().serverAdd+"/user/signup";
    if(validateEmail(email)) {
      if (validateMobile(mobile)) {
        reqBody = {
          "username": username,
          "email": email,
          "mobile_no": mobile,
          "password": password
        };
      }
      else{
        var error = "Invalid Mobile Number";
        _showToast(error);
      }
    }
    else{
      var error = "Invalid Email";
      _showToast(error);
    }
    String jsonParam = json.encode(reqBody);

    if(jsonParam!=null){
      try{
        final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonParam,
        );
        var responseJson = json.decode(response.body.toString());
        print("response:");
        print(responseJson);
        
        if(responseJson["success"]==null)
          throw("Request wasn't handled");
        if(responseJson["success"]){

         Navigator.of(context).pushNamedAndRemoveUntil(HomePage.tag, (Route<dynamic> route) => false);
          
        }
    
        else {
          print("Registration failed");
          Navigator.pop(context);
          _showToast(responseJson["error"]);
        }
      } catch(e){
        Navigator.pop(context);
        print("catching exception");
        print(e);
      }      
    }
  }

  
  // make post request for login
  
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
        content: Text(error),
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
  bool validateMobile(String value) {
    if (value.length != 10)
      return false;
    else
      return true;
  }

  _authDetails(String token, bool isAuth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuth', isAuth);
    await prefs.setString('token', token);
    print(prefs.getBool('isAuth'));
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

     final username = TextFormField(
      keyboardType: TextInputType.text,
      controller: userNameController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final mobileNumber = TextFormField(
      keyboardType: TextInputType.number,
      controller: mobileController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Mobile Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
            var usernameVal = userNameController.text;
            var mobileVal = mobileController.text;
            var emailVal = emailController.text;
            var passVal = passwordController.text;
            //SendOTP(mobileVal,emailVal,usernameVal, passVal);
            showDemoDialog<int>(dismissable: false,
            context: context,
            child: progressLoader
            );
            
            UserRegister(usernameVal,emailVal, mobileVal,passVal);
             
       //     Navigator.of(context).pushNamedAndRemoveUntil(MobileVerificationPage.tag, (Route<dynamic> route) => false);
            
          },
          color: Colors.lightBlueAccent,
          child: Text('Register', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

 Widget backButton = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BackButton(),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: backButton, title: new Text('Register'),),
      body: new Builder(builder: (BuildContext context) {
      scaffoldContext = context;
      return new Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            username,
            SizedBox(height: 8.0,),
            email,
            SizedBox(height: 8.0),
            mobileNumber,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            registerButton
          ],
        ),
      );
      }));
  }
}