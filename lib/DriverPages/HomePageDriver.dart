import 'dart:async';

import 'package:driverapp/Models/Delivery.dart';
import 'package:driverapp/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/User.dart';
import 'package:flutter_ajanuw_android_pip/flutter_ajanuw_android_pip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
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
  List<Delivery> dels;
  bool showMore = false;
  UserDriver driver;

  void _onRefresh(BuildContext context) async {
    print('working properly');
    reloadUser();
    getDocs();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void reloadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    HTTPHandler().registerVerifyOtpDriver([
      widget.userDriver.phone,
      prefs.getString('otp'),
      true,
    ]).then((value) {
      driver = UserDriver.fromJson(value[1]);
    });
  }

  @override
  void initState() {
    super.initState();
    driver = widget.userDriver;
    getDocs();
  }

  void getDocs() async {
    Map d = await HTTPHandler().getDocs(driver.id);
    List<Delivery> dels = await HTTPHandler().getpreviousLoads(driver.id);
    setState(() {
      docs = d;
      this.dels = dels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          FlutterAndroidPip.pip();
        });
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: (MediaQuery.of(context).size.height > 200.0)
            ? Stack(
                children: [
                  SmartRefresher(
                    controller: _refreshController,
                    onRefresh: () => _onRefresh(context),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 60.0,
                        left: 20.0,
                        right: 20.0,
                        bottom: 80.0,
                      ),
                      child: (docs == null || dels == null)
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20.0,
                                            backgroundImage: (docs['selfie'] ==
                                                    null)
                                                ? AssetImage(
                                                    'assets/icon/app.png')
                                                : NetworkImage(
                                                    'https://truckwale.co.in/${docs['selfie']}'),
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            driver.name.split(' ')[0],
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Text(
                                            (docs['truck verified'] == '1')
                                                ? 'Verified'
                                                : 'Not Verified'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.0),
                                  ListTile(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      delSelector,
                                      arguments: driver,
                                    ),
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
                                  SingleChildScrollView(
                                    child: Column(
                                      children: dels
                                          .map(
                                            (e) => Container(
                                              margin:
                                                  const EdgeInsets.all(10.0),
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                          'Post Id : ',
                                                          style: TextStyle(
                                                              fontSize: 15.0),
                                                        ),
                                                      ),
                                                      Text(
                                                        e.postId,
                                                        style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20.0),
                                                  Column(
                                                    children:
                                                        e.sources.map((e1) {
                                                      if (e.sources
                                                              .indexOf(e1) ==
                                                          0)
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: 15.0,
                                                                  height: 15.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .transparent,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                              .green[
                                                                          600],
                                                                      width:
                                                                          3.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        10.0),
                                                                Flexible(
                                                                  child: Text(
                                                                    '${e1.source}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 5.0,
                                                                vertical: 3.0,
                                                              ),
                                                              height: 5.0,
                                                              width: 1.5,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 5.0,
                                                                vertical: 3.0,
                                                              ),
                                                              height: 5.0,
                                                              width: 1.5,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ],
                                                        );
                                                      else
                                                        return SizedBox();
                                                    }).toList(),
                                                  ),
                                                  Column(
                                                    children: e.destinations
                                                        .map((e1) {
                                                      if (e.destinations
                                                              .indexOf(e1) ==
                                                          e.destinations
                                                                  .length -
                                                              1)
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: 15.0,
                                                                  height: 15.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .transparent,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                              .red[
                                                                          600],
                                                                      width:
                                                                          3.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        10.0),
                                                                Flexible(
                                                                  child: Text(
                                                                    '${e1.destination}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            if (e.destinations
                                                                    .indexOf(
                                                                        e1) !=
                                                                (e.destinations
                                                                        .length -
                                                                    1))
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      5.0,
                                                                  vertical: 3.0,
                                                                ),
                                                                height: 5.0,
                                                                width: 1.5,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            if (e.destinations
                                                                    .indexOf(
                                                                        e1) !=
                                                                (e.destinations
                                                                        .length -
                                                                    1))
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      5.0,
                                                                  vertical: 3.0,
                                                                ),
                                                                height: 5.0,
                                                                width: 1.5,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                          ],
                                                        );
                                                      else
                                                        return SizedBox();
                                                    }).toList(),
                                                  ),
                                                  SizedBox(height: 30.0),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Contact Person',
                                                            style: TextStyle(
                                                              fontSize: 13.0,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                          SizedBox(height: 8.0),
                                                          Text(
                                                            '${e.contactPerson}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 25.0),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Material',
                                                        style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.0),
                                                      Text(
                                                        '${e.material}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (!showMore)
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                  if (!showMore)
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          showMore = true;
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 13.0,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          border: Border.all(
                                                            width: 0.3,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(Icons
                                                                .arrow_drop_down),
                                                            Text('See More'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  if (showMore)
                                                    SizedBox(height: 20.0),
                                                  if (showMore)
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Payment Mode',
                                                          style: TextStyle(
                                                            fontSize: 13.0,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.0),
                                                        Text(
                                                          '${e.paymentMode['mode name']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (showMore)
                                                    if (e.paymentMode[
                                                            'mode name'] ==
                                                        'Advance Pay')
                                                      SizedBox(height: 20.0),
                                                  if (showMore)
                                                    if (e.paymentMode[
                                                            'mode name'] ==
                                                        'Advance Pay')
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Name',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      13.0,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 8.0),
                                                              Text(
                                                                'Advance',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          if (showMore)
                                                            SizedBox(
                                                                width: 25.0),
                                                          if (showMore)
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Amount',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Text(
                                                                  '${e.paymentMode['payment']['advance amount']['amount']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          if (showMore)
                                                            SizedBox(
                                                                width: 25.0),
                                                          if (showMore)
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Status',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Text(
                                                                  (e.paymentMode['payment']['advance amount']
                                                                              [
                                                                              'status'] ==
                                                                          '0')
                                                                      ? 'Due'
                                                                      : 'Paid',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                  if (showMore)
                                                    SizedBox(height: 20.0),
                                                  if (showMore)
                                                    Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Name',
                                                              style: TextStyle(
                                                                fontSize: 13.0,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            Text(
                                                              'Remaining',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 25.0),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Amount',
                                                              style: TextStyle(
                                                                fontSize: 13.0,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            Text(
                                                              '${e.paymentMode['payment']['remaining amount']['amount']}',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 25.0),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Status',
                                                              style: TextStyle(
                                                                fontSize: 13.0,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            Text(
                                                              (e.paymentMode['payment']
                                                                              [
                                                                              'remaining amount']
                                                                          [
                                                                          'status'] ==
                                                                      '0')
                                                                  ? 'Due'
                                                                  : 'Paid',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  if (showMore)
                                                    SizedBox(height: 20.0),
                                                  if (showMore)
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Trip Started',
                                                          style: TextStyle(
                                                            fontSize: 13.0,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.0),
                                                        Text(
                                                          e.data['trip start'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (showMore)
                                                    SizedBox(height: 20.0),
                                                  if (showMore)
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Trip End',
                                                          style: TextStyle(
                                                            fontSize: 13.0,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.0),
                                                        Text(
                                                          e.data['trip end'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (showMore) Divider(),
                                                  if (showMore)
                                                    GestureDetector(
                                                      onTap: () {
                                                        UrlLauncher.launch(
                                                            "tel:${e.contactPersonPhone}");
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.call),
                                                          SizedBox(width: 5.0),
                                                          Text(
                                                              '${e.contactPerson}'),
                                                        ],
                                                      ),
                                                    ),
                                                  if (showMore)
                                                    SizedBox(height: 20.0),
                                                  if (showMore)
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          showMore = false;
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 13.0,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          border: Border.all(
                                                            width: 0.3,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(Icons
                                                                .arrow_drop_up),
                                                            Text('See Less'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Container(
                    color: Color.fromRGBO(234, 215, 207, 1),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/pip.gif',
                      width: double.infinity,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/images/logo_white.png',
                        height: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: (MediaQuery.of(context).size.height > 200.0)
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                color: Colors.black87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => FlutterAndroidPip.pip(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.picture_in_picture,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          Text(
                            'PIP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        truckDocs,
                        arguments: [
                          widget.userDriver,
                          docs,
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pages,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          Text(
                            'Truck Docs',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        driverDocsUploadPage,
                        arguments: [
                          widget.userDriver,
                          docs,
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pages,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          Text(
                            'My Docs',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => HTTPHandler().signOut(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          Text(
                            'Log Out',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ),
    );
  }
}
