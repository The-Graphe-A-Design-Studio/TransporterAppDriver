import 'package:driverapp/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/User.dart';
import 'package:driverapp/BottomSheets/AccountBottomSheetLoggedIn.dart';

class HomePageDriver extends StatefulWidget {
  final UserDriver userDriver;
  HomePageDriver({Key key, this.userDriver}) : super(key: key);

  @override
  _HomePageDriverState createState() => _HomePageDriverState();
}

class _HomePageDriverState extends State<HomePageDriver> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xff252427),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              SizedBox(
                height: 75.0,
              ),
              Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: "WhiteLogo",
                          child: Image(
                            image: AssetImage('assets/images/logo_white.png'),
                            height: 145.0,
                            width: 145.0,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "You Are Logged in : Name - ${widget.userDriver.name}",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.35,
                            ),
                            GestureDetector(
                              onTap: () {
                                HTTPHandler().signOut(context);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.38,
                                  height:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 18.0, bottom: 10.0),
                                      child: Text(
                                        "Sign Out",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            driverDocsUploadPage,
                            arguments: widget.userDriver,
                          ),
                          child: Container(
                            height: 50.0,
                            width: 200.0,
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Text('Docs'),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            newDelivery,
                            arguments: widget.userDriver,
                          ),
                          child: Container(
                            height: 50.0,
                            width: 200.0,
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Text('Add Delivery'),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            deliveriesPage,
                            arguments: widget.userDriver,
                          ),
                          child: Container(
                            height: 50.0,
                            width: 200.0,
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Text('My Deliveries'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.08,
            minChildSize: 0.08,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Hero(
                tag: 'AnimeBottom',
                child: Container(
                    margin: EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    child: AccountBottomSheetLoggedIn(
                        scrollController: scrollController)),
              );
            },
          ),
        ],
      ),
    );
  }
}
