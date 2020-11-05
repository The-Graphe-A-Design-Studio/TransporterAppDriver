import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/User.dart';
import 'package:driverapp/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePageDriver extends StatefulWidget {
  final UserDriver userDriver;
  HomePageDriver({Key key, this.userDriver}) : super(key: key);

  @override
  _HomePageDriverState createState() => _HomePageDriverState();
}

class _HomePageDriverState extends State<HomePageDriver> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Map docs;

  void _onRefresh(BuildContext context) async {
    print('working properly');
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    getDocs();
    getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((value1) {
      HTTPHandler().updateLocation([
        '',
        value1.latitude.toString(),
        value1.longitude.toString(),
        widget.userDriver.id,
      ]);
    });

    Timer.periodic(const Duration(seconds: 2), (_) {
      getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((value1) {
        HTTPHandler().updateLocation([
          '',
          value1.latitude.toString(),
          value1.longitude.toString(),
          widget.userDriver.id,
        ]);
      });
    });
  }

  void getDocs() async {
    Map d = await HTTPHandler().getDocs(widget.userDriver.id);
    setState(() {
      docs = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 60.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.black,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          widget.userDriver.name.split(' ')[0],
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 15.0,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                      child: Text('Call Us'),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                ListTile(
                  tileColor: Colors.black,
                  title: Text(
                    'New Deliveries',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Previous Orders',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Divider(),
              ],
            ),
          ),
          //   SmartRefresher(
          //     controller: _refreshController,
          //     onRefresh: () => _onRefresh(context),
          //     child: Column(
          //       children: <Widget>[
          //         SizedBox(
          //           height: 75.0,
          //         ),
          //         Center(
          //           child: SingleChildScrollView(
          //             child: Center(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: <Widget>[
          //                   Hero(
          //                     tag: "WhiteLogo",
          //                     child: Image(
          //                       image: AssetImage('assets/images/logo_white.png'),
          //                       height: 145.0,
          //                       width: 145.0,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: 30.0,
          //                   ),
          //                   Text(
          //                     "You Are Logged in : Name - ${widget.userDriver.name.split(' ')[0]}",
          //                     style: TextStyle(
          //                       fontSize: 18.0,
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black87,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: 30.0,
          //                   ),
          //                   Stack(
          //                     children: <Widget>[
          //                       Container(
          //                         decoration: BoxDecoration(
          //                           color: Colors.grey[200],
          //                           borderRadius: BorderRadius.circular(20),
          //                         ),
          //                         width: MediaQuery.of(context).size.width * 0.7,
          //                         height:
          //                             MediaQuery.of(context).size.width * 0.35,
          //                       ),
          //                       GestureDetector(
          //                         onTap: () {
          //                           HTTPHandler().signOut(context);
          //                         },
          //                         child: Container(
          //                             decoration: BoxDecoration(
          //                               color: Colors.black87,
          //                               borderRadius: BorderRadius.circular(20),
          //                             ),
          //                             width: MediaQuery.of(context).size.width *
          //                                 0.38,
          //                             height: MediaQuery.of(context).size.width *
          //                                 0.35,
          //                             child: Align(
          //                               alignment: Alignment.bottomLeft,
          //                               child: Padding(
          //                                 padding: EdgeInsets.only(
          //                                     left: 18.0, bottom: 10.0),
          //                                 child: Text(
          //                                   "Sign Out",
          //                                   style: TextStyle(
          //                                     fontWeight: FontWeight.bold,
          //                                     fontSize: 17.0,
          //                                     color: Colors.white,
          //                                   ),
          //                                 ),
          //                               ),
          //                             )),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
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
                      color: Colors.black87,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    child: AccountBottomSheetLoggedIn(
                      scrollController: scrollController,
                      userDriver: widget.userDriver,
                      data: docs,
                    )),
              );
            },
          ),
        ],
      ),
    );
  }
}
