import 'package:carousel_slider/carousel_slider.dart';
import 'package:driverapp/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:flutter/material.dart';

final List<Color> imgList = [
  Colors.green,
  Colors.red,
  Colors.yellow,
  Colors.white,
  Colors.blue,
];

class DriverUpcomingOrder extends StatefulWidget {
  @override
  _DriverUpcomingOrderState createState() => new _DriverUpcomingOrderState();
}

class _DriverUpcomingOrderState extends State<DriverUpcomingOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 60.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Upcoming",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Orders",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40.0),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                CarouselSlider(
                  items: imgList.map((imageLink) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              height: 500.0,
                              padding: EdgeInsets.all(22.0),
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Color(0xff252427)),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 4.0,
                                              right: 20.0,
                                              left: 20.0,
                                              bottom: 4.0),
                                          child: Text("WB 02Q 9401"),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "KOL",
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Icon(
                                        Icons.directions_car,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text("DEL",
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                          )),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    "Transporter Name",
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Client",
                                            style: TextStyle(
                                                color: Colors.blueGrey
                                                    .withOpacity(0.9)),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text("Transporter User"),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date",
                                            style: TextStyle(
                                                color: Colors.blueGrey
                                                    .withOpacity(0.9)),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text("15 May, 2020"),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 1.0,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    "Pickup Address",
                                    style: TextStyle(
                                        color:
                                            Colors.blueGrey.withOpacity(0.9)),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text("Road 15a, Jheel Road, Bank plot"),
                                  Text("Kolkata - 700075"),
                                  SizedBox(height: 20.0),
                                  Text(
                                    "Delivery Address",
                                    style: TextStyle(
                                        color:
                                            Colors.blueGrey.withOpacity(0.9)),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text("Road 15a, Jheel Road, Bank plot"),
                                  Text("Kolkata - 700075"),
                                ],
                              ),
                            ),
                            Positioned(
                              child: const Divider(
                                color: Colors.black12,
                                height: 1,
                                thickness: 1,
                              ),
                              top: 350.0,
                              left: 0,
                              right: 0,
                            ),
                            Positioned(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(100.0),
                                      bottomRight: Radius.circular(100.0)),
                                  color: Color(0xff252427),
                                ),
                                height: 60.0,
                                width: 30.0,
                              ),
                              top: 320.0,
                              left: -10,
                            ),
                            Positioned(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(100.0),
                                      bottomLeft: Radius.circular(100.0)),
                                  color: Color(0xff252427),
                                ),
                                height: 60.0,
                                width: 30.0,
                              ),
                              top: 320.0,
                              right: -10,
                            ),
                            Positioned(
                              child: Opacity(
                                child: Image.asset(
                                  "assets/images/barCode.png",
                                  height: 45.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  fit: BoxFit.fill,
                                ),
                                opacity: 0.6,
                              ),
                              left: 40.0,
                              right: 40.0,
                              top: 375,
                            ),
                            Positioned(
                              child: FlatButton(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.file_upload,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Text(
                                      "Share",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    )
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                ),
                                onPressed: () {},
                              ),
                              left: 100.0,
                              right: 100.0,
                              top: 430,
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 500.0,
                    reverse: false,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                    initialPage: 0,
                    scrollDirection: Axis.horizontal,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                  ),
                ),
                SizedBox(
                  height: 100.0,
                ),
              ],
            ),
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
