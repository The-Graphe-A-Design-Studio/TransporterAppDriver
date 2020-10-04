import 'package:driverapp/DialogScreens/DialogFailed.dart';
import 'package:driverapp/DialogScreens/DialogProcessing.dart';
import 'package:driverapp/DialogScreens/DialogSuccess.dart';
import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/User.dart';
import 'package:driverapp/MyConstants.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class AddDelivery extends StatefulWidget {
  final UserDriver userDriver;

  AddDelivery({Key key, @required this.userDriver}) : super(key: key);

  @override
  _AddDeliveryState createState() => _AddDeliveryState();
}

class _AddDeliveryState extends State<AddDelivery> {
  var delIdController, otpController;

  void postOTPVerification() async {
    DialogProcessing().showCustomDialog(context,
        title: "Verifying OTP", text: "Processing, Please Wait!");
    HTTPHandler().newOrderOTPVerification([
      widget.userDriver.id,
      delIdController.text,
      otpController.text,
    ]).then((value) async {
      if (value.success) {
        Navigator.pop(context);
        DialogSuccess().showCustomDialog(context, title: "Verifying OTP");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, deliveriesPage,
            arguments: widget.userDriver);
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

  Widget getDocsBottomSheet(context, ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        homePageDriver,
                        arguments: widget.userDriver,
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xff252427),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Material(
                child: TextFormField(
                  controller: delIdController,
                  enabled: true,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.dialpad),
                    labelText: "Delivery ID",
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Material(
                child: TextFormField(
                  controller: otpController,
                  enabled: true,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.dialpad),
                    labelText: "OTP",
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (delIdController.text == '' ||
                        otpController.text == '') {
                      Toast.show(
                        'Missing Credentials',
                        context,
                        gravity: Toast.CENTER,
                        duration: Toast.LENGTH_LONG,
                      );
                      return;
                    }
                    postOTPVerification();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Update Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff252427),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2.0, color: Color(0xff252427)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget getCustomWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
          ),
          Text(
            "New",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Delivery",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    delIdController = TextEditingController();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    delIdController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Stack(
        children: <Widget>[
          getCustomWidget(context),
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Hero(
                tag: 'AnimeBottom',
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10.0,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: getDocsBottomSheet(
                      context,
                      scrollController,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
