import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driverapp/Models/User.dart';
import 'package:driverapp/MyConstants.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserDriver userDriver;
  String userType;

  Future<bool> doSomeAction() async {
    await Future.delayed(Duration(seconds: 2), () {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool("rememberMe");
    userType = prefs.getString("userType");
    if (rememberMe == true) {
      if (userType == driverUser) {
        userDriver =
            UserDriver.fromJson(json.decode(prefs.getString("userData")));
      }
    }
    return Future.value(rememberMe);
  }

  @override
  void initState() {
    super.initState();
    doSomeAction().then((value) {
      if (value == true) {
        if (userType == driverUser) {
          Navigator.pushReplacementNamed(context, homePageDriver,
              arguments: userDriver);
        } else {
          Navigator.pushReplacementNamed(context, driverOptionPage);
        }
      } else {
        Navigator.pushReplacementNamed(context, driverOptionPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Hero(
          tag: "WhiteLogo",
          child: Image(
            image: AssetImage('assets/images/logo_white.png'),
            height: 200.0,
            width: 200.0,
          ),
        ),
      ),
    );
  }
}
