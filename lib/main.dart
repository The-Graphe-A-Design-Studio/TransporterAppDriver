import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:driverapp/RouteGenerator.dart';
import 'package:driverapp/SplashScreen.dart';

import 'MyConstants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(StartApp());
}

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transportation App',
      theme: ThemeData(
        primaryColor: Color(0xff252427),
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
