import 'dart:async';

import 'package:driverapp/DialogScreens/DialogFailed.dart';
import 'package:driverapp/DialogScreens/DialogProcessing.dart';
import 'package:driverapp/DialogScreens/DialogSuccess.dart';
import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/Delivery.dart';
import 'package:driverapp/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DeliveriesPage extends StatefulWidget {
  final UserDriver userDriver;

  DeliveriesPage({Key key, @required this.userDriver}) : super(key: key);

  @override
  _DeliveriesPageState createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage> {
  Delivery delivery;
  bool controller = false;

  Widget item(String title, String value) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(height: 5.0),
        ],
      );

  @override
  void initState() {
    super.initState();
    HTTPHandler().getNewDelivery([widget.userDriver.phone]).then((value) {
      if (value != null) {
        Timer.periodic(const Duration(minutes: 10), (_) {
          getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
              .then((value1) {
            print(value);
            HTTPHandler().updateLocation(
                [value.deliveryIdForTruck, value1.latitude, value1.longitude]);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Deliveries'),
      ),
      body: (delivery == null && !controller)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : (delivery == null && controller)
              ? Center(
                  child: Text(
                    'No New Deliveries',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  height: 240.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      item(
                          'Delivery Id for Truck', delivery.deliveryIdForTruck),
                      item('Post Id', delivery.postId),
                      item('Customer Id', delivery.customerId),
                      Column(
                        children: delivery.sources
                            .map((e) => item('Source ${e.index}',
                                '${e.source.substring(0, 30)}...'))
                            .toList(),
                      ),
                      Column(
                        children: delivery.destinations
                            .map((e) => item('Destination ${e.index}',
                                '${e.destination.substring(0, 30)}...'))
                            .toList(),
                      ),
                      item('Material', delivery.material),
                      item('Contact Person', delivery.contactPerson),
                      item('Contact Person Phone', delivery.contactPersonPhone),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: RaisedButton.icon(
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
                            DialogProcessing().showCustomDialog(context,
                                title: "Complete Trip",
                                text: "Processing, Please Wait!");
                            HTTPHandler().completeTrip([
                              delivery.deliveryIdForTruck
                            ]).then((value) async {
                              Navigator.pop(context);
                              if (value.success) {
                                DialogSuccess().showCustomDialog(context,
                                    title: "Complete Trip");
                                await Future.delayed(
                                    Duration(seconds: 1), () {});
                                Navigator.pop(context);
                                Navigator.of(context).pop();
                              } else {
                                DialogFailed().showCustomDialog(context,
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
                              await Future.delayed(Duration(seconds: 3), () {});
                              Navigator.pop(context);
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
