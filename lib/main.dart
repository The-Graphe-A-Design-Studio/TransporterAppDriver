import 'dart:convert';

import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:driverapp/RouteGenerator.dart';
import 'package:driverapp/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyConstants.dart';

import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import './notification.dart' as notif;

const fetchBackground = "fetchBackground";

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        // Geolocator geoLocator = Geolocator()..forceAndroidLocationManager = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool rememberMe = prefs.getBool("rememberMe");
        String userType = prefs.getString("userType");
        if (rememberMe == true) {
          if (userType == driverUser) {
            Position userLocation = await getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            notif.Notification notification = new notif.Notification();
            notification.showNotificationWithoutSound(userLocation);
            print('work is simping');

            UserDriver userDriver =
                UserDriver.fromJson(json.decode(prefs.getString("userData")));

            HTTPHandler().updateLocation([
              '',
              userLocation.latitude.toString(),
              userLocation.longitude.toString(),
              userDriver.id,
            ]);
          }
        }
        break;
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(StartApp());
}

class StartApp extends StatefulWidget {
  @override
  _StartAppState createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  @override
  void initState() {
    super.initState();

    // We don't need it anymore since it will be executed in background
    //this._getUserPosition();

    Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    Workmanager.registerPeriodicTask(
      "1",
      fetchBackground,
      frequency: Duration(minutes: 15),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: Text('Check BC'),
  //       ),
  //       body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               "",
  //               style: Theme.of(context).textTheme.display1,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transportation App',
      theme: ThemeData(
        // primaryColor: Color(0xff252427),
        primaryColor: Colors.white,
        canvasColor: Colors.transparent,
        accentColor: Colors.black12,
        accentColorBrightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: splashPage,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: SplashScreen(),
    );
  }
}
