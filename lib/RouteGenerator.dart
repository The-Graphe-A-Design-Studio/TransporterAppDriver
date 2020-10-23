import 'package:driverapp/DriverPages/AddDelivery.dart';
import 'package:driverapp/DriverPages/DeliveriesPage.dart';
import 'package:driverapp/DriverPages/DeliverySelectorPage.dart';
import 'package:driverapp/DriverPages/DriverDocsUploadPage.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/CommonPages/FadeTransition.dart';
import 'package:driverapp/CommonPages/IntroPageLoginOptions.dart';
import 'package:driverapp/DriverPages/DriverOptionsPage.dart';
import 'package:driverapp/DriverPages/DriverUpcomingOrder.dart';
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
      case introLoginOptionPage:
        return FadeRoute(page: IntroPageLoginOptions());
      case driverOptionPage:
        return FadeRoute(page: DriverOptionsPage());

      //Pages once the user is LoggedIn - Driver
      case homePageDriver:
        return FadeRoute(page: HomePageDriver(userDriver: args));
      case driverUpcomingOrderPage:
        return FadeRoute(page: DriverUpcomingOrder());
      case driverDocsUploadPage:
        return FadeRoute(
          page: DriverDocsUploadPage(userDriver: args),
        );
      case deliveriesPage:
        return FadeRoute(page: DeliveriesPage(args: args));
      case newDelivery:
        return FadeRoute(page: AddDelivery(userDriver: args));
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
