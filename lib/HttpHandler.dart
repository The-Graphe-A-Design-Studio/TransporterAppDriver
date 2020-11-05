import 'dart:convert';
import 'package:driverapp/Models/Delivery.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driverapp/DialogScreens/DialogProcessing.dart';
import 'package:driverapp/DialogScreens/DialogSuccess.dart';
import 'package:driverapp/MyConstants.dart';
import 'package:driverapp/PostMethodResult.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
        context, driverOptionPage, (route) => false);
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
      final fcm = FirebaseMessaging();
      fcm.requestNotificationPermissions();
      fcm.configure();
      var token = await fcm.getToken();
      print('token => $token');
      var result = await http.post("$baseURLDriver/driver_enter", body: {
        'trk_dr_phone_code': '91',
        'trk_dr_phone': data[0],
        'trk_dr_token': token,
      });
      return PostResultOne.fromJson(json.decode(result.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> addUpdateSelfie(List data) async {
    try {
      var url = '$baseURLDriver/driver_docs';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_id'] = data[0];
      request.files
          .add(await http.MultipartFile.fromPath('trk_dr_selfie', data[1]));

      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<PostResultOne> addUpdateLicense(List data) async {
    try {
      var url = '$baseURLDriver/driver_docs';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['trk_id'] = data[0];
      request.files
          .add(await http.MultipartFile.fromPath('trk_dr_license', data[1]));

      var result = await request.send();
      var finalResult = await http.Response.fromStream(result);
      return PostResultOne.fromJson(json.decode(finalResult.body));
    } catch (error) {
      throw error;
    }
  }

  Future<Delivery> getNewDelivery(List data) async {
    try {
      var response = await http.post(
        '$baseURLDriver/new_delivery',
        body: {'delivery_truck_id': data[0]},
      );

      if (json.decode(response.body)['success'] == '0') return null;

      return Delivery.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<PostResultOne> completeTrip(List data) async {
    try {
      var response = await http.post('$baseURLDriver/new_delivery', body: {
        'del_trk_id': data[0],
      });

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateLocation(List data) async {
    try {
      http.post('$baseURLDriver/my_location', body: {
        'del_trk_id': data[0],
        'lat': data[1],
        'lng': data[2],
        'truck_id': data[3],
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<PostResultOne> newOrderOTPVerification(List data) async {
    try {
      var response = await http.post('$baseURLDriver/new_delivery', body: {
        'truck_id': data[0],
        'del_trk_id': data[1],
        'otp': data[2],
      });

      return PostResultOne.fromJson(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> getNewDel(String mobileNo) async {
    try {
      print(mobileNo);
      var response = await http.post(
        '$baseURLDriver/get_delivery',
        body: {
          'driver_phone': mobileNo,
        },
      );

      print(response.body);

      if (json.decode(response.body) is List)
        return json.decode(response.body);
      else
        return null;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Map> getDocs(String truckId) async {
    try {
      var response = await http
          .post('$baseURLDriver/driver_docs', body: {'truck_id': truckId});

      return json.decode(response.body);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
