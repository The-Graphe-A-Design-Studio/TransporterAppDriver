import 'dart:convert';
import 'dart:io';

import 'package:driverapp/DialogScreens/DialogFailed.dart';
import 'package:driverapp/DialogScreens/DialogProcessing.dart';
import 'package:driverapp/DialogScreens/DialogSuccess.dart';
import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/User.dart';
import 'package:driverapp/MyConstants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class DriverDocsUploadPage extends StatefulWidget {
  final UserDriver userDriver;
  final Map docs;

  DriverDocsUploadPage({
    Key key,
    @required this.userDriver,
    @required this.docs,
  }) : super(key: key);

  @override
  _DriverDocsUploadPageState createState() => _DriverDocsUploadPageState();
}

class _DriverDocsUploadPageState extends State<DriverDocsUploadPage> {
  var selfieController, licenseController;
  Future<File> imageFile;
  Future<File> imageFile1;

  pickImageFromSystem(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(
        source: source,
        imageQuality: 15,
      );
    });
  }

  pickImageFromSystem1(ImageSource source) {
    setState(() {
      imageFile1 = ImagePicker.pickImage(source: source, imageQuality: 15);
    });
  }

  Widget _imagePreview() => (imageFile != null)
      ? FutureBuilder<File>(
          future: imageFile,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.data != null)
              selfieController.text = snapshot.data.path;
            return Container(
              height: 250.0,
              width: double.infinity,
              decoration: (imageFile != null && snapshot.data != null)
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(snapshot.data),
                        fit: BoxFit.contain,
                      ),
                    )
                  : BoxDecoration(),
            );
          },
        )
      : Container();

  Widget _imagePreview1() => (imageFile1 != null)
      ? FutureBuilder<File>(
          future: imageFile1,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.data != null)
              licenseController.text = snapshot.data.path;
            return Container(
              height: 250.0,
              width: double.infinity,
              decoration: (imageFile1 != null && snapshot.data != null)
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(snapshot.data),
                        fit: BoxFit.contain,
                      ),
                    )
                  : BoxDecoration(),
            );
          },
        )
      : Container();

  void postUpdateRequestSelfie() async {
    if (imageFile == null) {
      print('no change in selfie');
      postUpdateRequestLicense();
    } else {
      print('change in selfie');
      DialogProcessing().showCustomDialog(context,
          title: "Uploading Selfie", text: "Processing, Please Wait!");
      HTTPHandler().addUpdateSelfie(
          [widget.userDriver.id, (await imageFile).path]).then((value) async {
        if (value.success) {
          Navigator.pop(context);
          DialogSuccess().showCustomDialog(context, title: "Uploading Selfie");
          await Future.delayed(Duration(seconds: 1), () {});
          Navigator.pop(context);
          postUpdateRequestLicense();
        } else {
          Navigator.pop(context);
          DialogFailed().showCustomDialog(context,
              title: "Uploading Selfie", text: value.message);
          await Future.delayed(Duration(seconds: 3), () {});
          Navigator.pop(context);
        }
      }).catchError((e) async {
        print(e);
        Navigator.pop(context);
        DialogFailed().showCustomDialog(context,
            title: "Uploading Selfie", text: "Network Error");
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      });
    }
  }

  void reloadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    HTTPHandler().registerVerifyOtpDriver([
      widget.userDriver.phone,
      prefs.getString('otp'),
      true,
    ]).then((value) {
      prefs.setBool("rememberMe", true);
      prefs.setString("userData", json.encode(value[1]));
      Navigator.pushNamedAndRemoveUntil(
        context,
        homePageDriver,
        (route) => false,
        arguments: UserDriver.fromJson(value[1]),
      );
    });
  }

  void postUpdateRequestLicense() async {
    if (imageFile1 == null) {
      print('no change in license');
      if (imageFile != null) {
        reloadUser();
        // HTTPHandler().signOut(context);
        // Toast.show(
        //   'Please login again to verify changes!',
        //   context,
        //   gravity: Toast.CENTER,
        //   duration: Toast.LENGTH_LONG,
        // );
      }
    } else {
      print('change in license');
      DialogProcessing().showCustomDialog(context,
          title: "Uploading License", text: "Processing, Please Wait!");
      HTTPHandler().addUpdateLicense(
          [widget.userDriver.id, (await imageFile1).path]).then((value) async {
        if (value.success) {
          Navigator.pop(context);
          DialogSuccess().showCustomDialog(context, title: "Uploading License");
          await Future.delayed(Duration(seconds: 1), () {});
          Navigator.pop(context);
          reloadUser();
          // HTTPHandler().signOut(context);
          // Toast.show(
          //   'Please login again to verify changes!',
          //   context,
          //   gravity: Toast.CENTER,
          //   duration: Toast.LENGTH_LONG,
          // );
        } else {
          Navigator.pop(context);
          DialogFailed().showCustomDialog(context,
              title: "Uploading License", text: value.message);
          await Future.delayed(Duration(seconds: 3), () {});
          Navigator.pop(context);
        }
      }).catchError((e) async {
        print(e);
        Navigator.pop(context);
        DialogFailed().showCustomDialog(context,
            title: "Uploading License", text: "Network Error");
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      });
    }
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
              GestureDetector(
                onTap: () => _showModalSheet(context),
                child: Material(
                  child: TextFormField(
                    controller: selfieController,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.dialpad),
                      labelText: "Selfie Image",
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
              ),
              SizedBox(
                height: 16.0,
              ),
              (imageFile != null)
                  ? _imagePreview()
                  : (selfieController.text != null)
                      ? Stack(
                          children: [
                            Container(
                              height: 250.0,
                              width: double.infinity,
                              child: PhotoView(
                                maxScale: PhotoViewComputedScale.contained,
                                imageProvider: NetworkImage(
                                    'https://truckwale.co.in/${selfieController.text}'),
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.white),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 100.0,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.black,
                                ),
                                child: Text(
                                  (widget.docs['selfie verified'] == '1')
                                      ? 'Verified'
                                      : 'Not Verified',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(),
              SizedBox(
                height: 16.0,
              ),
              GestureDetector(
                onTap: () => _showModalSheet1(context),
                child: Material(
                  child: TextFormField(
                    controller: licenseController,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.dialpad),
                      labelText: "License",
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
              ),
              SizedBox(
                height: 16.0,
              ),
              (imageFile1 != null)
                  ? _imagePreview1()
                  : (licenseController.text != null)
                      ? Stack(
                          children: [
                            Container(
                              height: 250.0,
                              width: double.infinity,
                              child: PhotoView(
                                maxScale: PhotoViewComputedScale.contained,
                                imageProvider: NetworkImage(
                                    'https://truckwale.co.in/${licenseController.text}'),
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.white),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 100.0,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.black,
                                ),
                                child: Text(
                                  (widget.docs['license verified'] == '1')
                                      ? 'Verified'
                                      : 'Not Verified',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(),
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    postUpdateRequestSelfie();
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
            "Your",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Documents",
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
    selfieController = TextEditingController();
    licenseController = TextEditingController();
    if (widget.docs['selfie'] != null)
      selfieController.text = widget.docs['selfie'];
    if (widget.docs['license'] != null)
      licenseController.text = widget.docs['license'];
  }

  @override
  void dispose() {
    selfieController.dispose();
    licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Documents'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        // controller: scrollController,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showModalSheet(context),
                  child: Material(
                    child: TextFormField(
                      controller: selfieController,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.dialpad),
                        labelText: "Selfie Image",
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
                ),
                SizedBox(
                  height: 16.0,
                ),
                (imageFile != null)
                    ? _imagePreview()
                    : (selfieController.text != null)
                        ? Stack(
                            children: [
                              Container(
                                height: 250.0,
                                width: double.infinity,
                                child: PhotoView(
                                  maxScale: PhotoViewComputedScale.contained,
                                  imageProvider: NetworkImage(
                                      'https://truckwale.co.in/${selfieController.text}'),
                                  backgroundDecoration:
                                      BoxDecoration(color: Colors.white),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 100.0,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.black,
                                  ),
                                  child: Text(
                                    (widget.docs['selfie verified'] == '1')
                                        ? 'Verified'
                                        : 'Not Verified',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(),
                SizedBox(
                  height: 16.0,
                ),
                GestureDetector(
                  onTap: () => _showModalSheet1(context),
                  child: Material(
                    child: TextFormField(
                      controller: licenseController,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.dialpad),
                        labelText: "License",
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
                ),
                SizedBox(
                  height: 16.0,
                ),
                (imageFile1 != null)
                    ? _imagePreview1()
                    : (licenseController.text != null)
                        ? Stack(
                            children: [
                              Container(
                                height: 250.0,
                                width: double.infinity,
                                child: PhotoView(
                                  maxScale: PhotoViewComputedScale.contained,
                                  imageProvider: NetworkImage(
                                      'https://truckwale.co.in/${licenseController.text}'),
                                  backgroundDecoration:
                                      BoxDecoration(color: Colors.white),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 100.0,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.black,
                                  ),
                                  child: Text(
                                    (widget.docs['license verified'] == '1')
                                        ? 'Verified'
                                        : 'Not Verified',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(),
                SizedBox(
                  height: 16.0,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      postUpdateRequestSelfie();
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
                        border:
                            Border.all(width: 2.0, color: Color(0xff252427)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showModalSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 150,
          color: Colors.black87,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  pickImageFromSystem(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.folder_open,
                      color: Colors.white,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  pickImageFromSystem(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });

  void _showModalSheet1(BuildContext context) {
    print('actually called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: 150,
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    pickImageFromSystem1(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.folder_open,
                        color: Colors.white,
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    pickImageFromSystem1(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
