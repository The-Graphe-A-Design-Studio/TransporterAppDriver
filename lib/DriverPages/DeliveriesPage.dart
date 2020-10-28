import 'dart:async';

import 'package:driverapp/DialogScreens/DialogFailed.dart';
import 'package:driverapp/DialogScreens/DialogProcessing.dart';
import 'package:driverapp/DialogScreens/DialogSuccess.dart';
import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/Delivery.dart';
import 'package:driverapp/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class DeliveriesPage extends StatefulWidget {
  // final UserDriver userDriver;
  final List args;

  DeliveriesPage({Key key, @required this.args}) : super(key: key);

  @override
  _DeliveriesPageState createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage> {
  Delivery delivery;
  bool controller = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _otpController;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(BuildContext context) async {
    // monitor network fetch
    print('working properly');
    getDelivery();
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void modal() => _scaffoldKey.currentState.showBottomSheet(
        (BuildContext context) => Container(
          padding: const EdgeInsets.only(bottom: 30.0),
          // height: 170.0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.dialpad),
                      labelText: "Enter OTP",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    if (_otpController.text == '')
                      Toast.show(
                        'Enter OTP First',
                        context,
                        gravity: Toast.CENTER,
                        duration: Toast.LENGTH_SHORT,
                      );
                    else
                      postOTPVerification();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      'Start Trip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
      );

  void postOTPVerification() async {
    DialogProcessing().showCustomDialog(context,
        title: "Verifying OTP", text: "Processing, Please Wait!");
    HTTPHandler().newOrderOTPVerification([
      delivery.truckId,
      delivery.deliveryIdForTruck,
      _otpController.text,
    ]).then((value) async {
      if (value.success) {
        Navigator.pop(context);
        DialogSuccess().showCustomDialog(context, title: "Verifying OTP");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.pop(context);
        getDelivery();
      } else {
        Navigator.pop(context);
        DialogFailed().showCustomDialog(context,
            title: "Verifying OTP", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((e) async {
      print(e);
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Verifying OTP", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  getDelivery() {
    print('${widget.args[1]} is it');
    HTTPHandler().getNewDelivery([widget.args[1]]).then((value) {
      if (value != null) {
        Timer.periodic(const Duration(minutes: 10), (_) {
          getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
              .then((value1) {
            print(value);
            HTTPHandler().updateLocation([
              value.deliveryIdForTruck,
              value1.latitude.toString(),
              value1.longitude.toString(),
              (widget.args[0] as UserDriver).id,
            ]);
          });
        });
      }
      setState(() {
        this.delivery = value;
        controller = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    getDelivery();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'My Deliveries',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: (delivery == null && !controller)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : (delivery == null && controller)
              ? SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(context),
                  child: Center(
                    child: Text(
                      'No New Deliveries',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(context),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: delivery.sources
                                  .map((e) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                MapsLauncher.launchCoordinates(
                                              double.parse(e.lat),
                                              double.parse(e.lng),
                                              e.destination,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 15.0,
                                                  height: 15.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.green[600],
                                                      width: 3.0,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.0),
                                                Flexible(
                                                  child: Text(
                                                    '${e.source}',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0,
                                              vertical: 3.0,
                                            ),
                                            height: 5.0,
                                            width: 1.5,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0,
                                              vertical: 3.0,
                                            ),
                                            height: 5.0,
                                            width: 1.5,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ))
                                  .toList(),
                            ),
                            Column(
                              children: delivery.destinations
                                  .map((e) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                MapsLauncher.launchCoordinates(
                                              double.parse(e.lat),
                                              double.parse(e.lng),
                                              e.destination,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 15.0,
                                                  height: 15.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.red[600],
                                                      width: 3.0,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.0),
                                                Flexible(
                                                  child: Text(
                                                    '${e.destination}',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (delivery.destinations
                                                  .indexOf(e) !=
                                              (delivery.destinations.length -
                                                  1))
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5.0,
                                                vertical: 3.0,
                                              ),
                                              height: 5.0,
                                              width: 1.5,
                                              color: Colors.grey,
                                            ),
                                          if (delivery.destinations
                                                  .indexOf(e) !=
                                              (delivery.destinations.length -
                                                  1))
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5.0,
                                                vertical: 3.0,
                                              ),
                                              height: 5.0,
                                              width: 1.5,
                                              color: Colors.grey,
                                            ),
                                        ],
                                      ))
                                  .toList(),
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contact Person',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${delivery.contactPerson}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 25.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      '${delivery.material}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact Person',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '${delivery.paymentMode['mode name']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            if (delivery.paymentMode['mode name'] ==
                                'Advance Pay')
                              SizedBox(height: 20.0),
                            if (delivery.paymentMode['mode name'] ==
                                'Advance Pay')
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Advance',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 25.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Amount',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '${delivery.paymentMode['payment']['advance amount']['amount']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 25.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        (delivery.paymentMode['payment']
                                                        ['advance amount']
                                                    ['status'] ==
                                                '0')
                                            ? 'Due'
                                            : 'Paid',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            SizedBox(height: 20.0),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Remaining',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 25.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${delivery.paymentMode['payment']['remaining amount']['amount']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 25.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      (delivery.paymentMode['payment']
                                                      ['remaining amount']
                                                  ['status'] ==
                                              '0')
                                          ? 'Due'
                                          : 'Paid',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    UrlLauncher.launch(
                                        "tel:${delivery.contactPersonPhone}");
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.call),
                                      SizedBox(width: 5.0),
                                      Text('${delivery.contactPerson}'),
                                    ],
                                  ),
                                ),
                                if (delivery.onTrip == '1')
                                  RaisedButton.icon(
                                    color: Colors.black,
                                    icon: Icon(
                                      Icons.accessible,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Start Trip',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () => modal(),
                                  ),
                                if (delivery.onTrip == '2')
                                  RaisedButton.icon(
                                    color: Colors.black,
                                    icon: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Complete Trip',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      DialogProcessing().showCustomDialog(
                                          context,
                                          title: "Complete Trip",
                                          text: "Processing, Please Wait!");
                                      HTTPHandler().completeTrip([
                                        delivery.deliveryIdForTruck
                                      ]).then((value) async {
                                        Navigator.pop(context);
                                        if (value.success) {
                                          DialogSuccess().showCustomDialog(
                                              context,
                                              title: "Complete Trip");
                                          await Future.delayed(
                                              Duration(seconds: 1), () {});
                                          Navigator.pop(context);
                                          Navigator.of(context).pop();
                                        } else {
                                          DialogFailed().showCustomDialog(
                                              context,
                                              title: "Complete Trip",
                                              text: value.message);
                                          await Future.delayed(
                                              Duration(seconds: 3), () {});
                                          Navigator.pop(context);
                                          Navigator.of(context).pop();
                                        }
                                      }).catchError((error) async {
                                        print(error);
                                        Navigator.pop(context);
                                        DialogFailed().showCustomDialog(context,
                                            title: "Complete Trip",
                                            text: "Network Error");
                                        await Future.delayed(
                                            Duration(seconds: 3), () {});
                                        Navigator.pop(context);
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
