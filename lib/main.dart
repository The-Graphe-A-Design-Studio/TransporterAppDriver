import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:driverapp/RouteGenerator.dart';
import 'package:driverapp/SplashScreen.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import 'MyConstants.dart';

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
