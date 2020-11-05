import 'package:driverapp/DriverPages/DeliveriesPage.dart';
import 'package:driverapp/DriverPages/DeliverySelectorPage.dart';
import 'package:driverapp/DriverPages/DriverDocsUploadPage.dart';
import 'package:driverapp/DriverPages/TruckDocuments.dart';
import 'package:driverapp/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/CommonPages/FadeTransition.dart';
import 'package:driverapp/DriverPages/DriverOptionsPage.dart';
import 'package:driverapp/DriverPages/HomePageDriver.dart';
import 'package:driverapp/MyConstants.dart';
import 'package:driverapp/SplashScreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      //Basic Pages
      case splashPage:
        return FadeRoute(page: SplashScreen());

      //Login or Signup Pages
      case driverOptionPage:
        return FadeRoute(page: DriverOptionsPage());

      //Pages once the user is LoggedIn - Driver
      case homePageDriver:
        return FadeRoute(page: HomePageDriver(userDriver: args));
      case driverDocsUploadPage:
        return FadeRoute(
          page: DriverDocsUploadPage(
            userDriver: ((args as List)[0] as UserDriver),
            docs: (args as List)[1],
          ),
        );

      case truckDocs:
        return FadeRoute(
            page: TruckDocuments(
          userDriver: ((args as List)[0] as UserDriver),
          docs: (args as List)[1],
        ));
        
      case deliveriesPage:
        return FadeRoute(page: DeliveriesPage(args: args));
      case delSelector:
        return FadeRoute(page: DeliverySelectorPage(user: args));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
