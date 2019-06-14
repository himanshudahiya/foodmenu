import 'package:flutter/material.dart';
import 'UserAcc.dart';
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Login.dart';
import 'Page2.dart';
import 'CitiesClass.dart';
class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  String title;

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String token;
  BuildContext scaffoldContext;
  UserAcc userAcc;
  List<String> cities = [];
  bool isLoaded = false;
  void logout() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', null);
    preferences.setBool('isAuth', false);
    Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.tag, (Route<dynamic> route) => false);
  }



  Future<UserAcc> UserAccount() async {
    String url = config().serverAdd+"/user/getuser";

    final preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");

      if (token != null) {
        final response = await http.get(url,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "Bearer " + token,
          },
        );
        var responseJson = json.decode(response.body.toString());
        print(response.body.toString());
        userAcc = createUserList(responseJson);
        return userAcc;
      }

    else{
      logout();
//      username = (userDetails[0]);
//      email = userDetails[1];
//      mobileNo = userDetails[2];
//      var message = userDetails[3];
//      userAcc = new UserAcc(username: username, email: email, mobileNo: mobileNo, message: message);
    }
    return userAcc;
  }
  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<List<String>> UserCities() async {
    String url = config().getCity;
    List<String> citiesListNew;
    final response = await http.get(url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8",
      },
    );
    var responseJson = json.decode(response.body.toString());
    CitiesList citiesList = CitiesList.fromJson(responseJson);
    citiesListNew = createCityList(citiesList);
    return citiesListNew;

  }

  List<String> createCityList(CitiesList data){
    List<String> cities = [];
    for(int i=0;i<data.city.length;i++){
      cities.add(data.city[i].localName);
    }
    return cities;
  }

  // get token and auth status from request response
  UserAcc createUserList(var data) {
    var message = data["message"];
    if (data["auth"] != null) {
      if (data["auth"] == false) {
        logout();
      }
    }
    else {
      if (message == "User Found") {
        username = data["username"];
        email = data["email"];
        mobileNo = data["mobile_no"].toString();
      }
      else {
        username = null;
        email = null;
        mobileNo = null;
      }
    }
      UserAcc userAcc = new UserAcc(username: username,
          email: email,
          mobileNo: mobileNo,
          message: message);
      return userAcc;

  }

  String username = "John Dee";
  String email = "example@abc.com";
  String mobileNo = "1234567890";
  void fetchCities(){
    UserCities().then((res) {
      setState(() {
        cities = res;
        isLoaded = true;
      });
    });
  }



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
  // qr code scan

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCities();
  }
  var selectedCity;
  var selectedType;
  @override
  Widget build(BuildContext context) {
    var cityDropDown = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: new DropdownButton<String>(
        items: cities.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),

        onChanged: (value) {
          setState((){
            selectedCity = value;
          });
        },
        hint: Text(
          "Please select the kitchen!",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        value: selectedCity,
      ),
    );
    var otherDropDown = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: new DropdownButton<String>(
        items: <String>['Dispatched', 'Wastage', 'Recieved'].map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),

        onChanged: (value) {
          setState((){
            selectedType = value;
          });
        },
        hint: Text(
          "Please select the disposal type!",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        value: selectedType,
      ),
    );
    var nextButton  = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            final pageRoute = MaterialPageRoute(builder: (context)=>Page2(cityName: selectedCity, type: selectedType,));
            Navigator.of(context).push(pageRoute);
          },
          color: Colors.lightBlueAccent,
          child: Text('Next ', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text('Food Tracker'),
        elevation: 0,
        centerTitle: false,

      ),

      body: new Builder(builder: (BuildContext context)
        {
        scaffoldContext = context;
        return (isLoaded)? new Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
             children: <Widget>[
               Text("${selectedDate.toLocal()}"),
               SizedBox(height: 20.0,),
               RaisedButton(
                 onPressed: () => _selectDate(context),
                 child: Text('Select date'),
               ),
              cityDropDown,
              otherDropDown,
              nextButton
            ],
          ),
        ) :  new Container(
          color: Colors.grey[300],
          width: 70.0,
          height: 70.0,
          child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
        );
        }));
            
   
  }
}
