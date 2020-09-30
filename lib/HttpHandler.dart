import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driverapp/DialogScreens/DialogProcessing.dart';
import 'package:driverapp/DialogScreens/DialogSuccess.dart';
import 'package:driverapp/Models/TruckCategory.dart';
import 'package:driverapp/MyConstants.dart';
import 'package:driverapp/PostMethodResult.dart';
import 'package:driverapp/Models/User.dart';

class HTTPHandler {
  String baseURLDriver = 'https://truckwale.co.in/api/driver';

  void signOut(BuildContext context) async {
    DialogProcessing().showCustomDialog(context,
        title: "Sign Out", text: "Processing, Please Wait!");
    await SharedPreferences.getInstance()
        .then((value) => value.setBool("rememberMe", false));
    await Future.delayed(Duration(seconds: 1), () {});
    Navigator.pop(context);
    DialogSuccess().showCustomDialog(context, title: "Sign Out");
    await Future.delayed(Duration(seconds: 1), () {});
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
        context, introLoginOptionPage, (route) => false);
  }

  Future<List<TruckCategory>> getTruckCategory() async {
    try {
      var result = await http
          .get("https://truckwale.co.in/api/truck_owner/truck_categories");
      var ret = json.decode(result.body);
      List<TruckCategory> list = [];
      for (var i in ret) {
        list.add(TruckCategory.fromJson(i));
      }
      return list;
    } catch (error) {
      throw error;
    }
  }

  /*-------------------------- Driver API's ---------------------------*/

  Future<List> registerVerifyOtpDriver(List data) async {
    try {
      var result = await http.post("$baseURLDriver/driver_verification",
          body: {'phone_number': data[0], 'otp': data[1]});
      var jsonResult = json.decode(result.body);
      if (jsonResult['success'] == '1') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', data[2]);
        prefs.setString('userType', driverUser);
        prefs.setString('userData', result.body);
        return [true, jsonResult];
      } else {
        PostResultOne postResultOne = PostResultOne.fromJson(jsonResult);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('rememberMe', false);
        return [false, postResultOne];
      }
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> registerResendOtpDriver(List data) async {
    try {
      var result = await http.post("$baseURLDriver/driver_verification", body: {
        'resend_otp': data[0],
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> loginDriver(List data) async {
    try {
      var result = await http.post("$baseURLDriver/driver_enter", body: {
        'trk_dr_phone_code': '91',
        'trk_dr_phone': data[0],
        'trk_dr_token': ' ',
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }
}
