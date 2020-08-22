import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/User.dart';
import 'package:driverapp/MyConstants.dart';
import 'package:driverapp/PostMethodResult.dart';
import 'package:driverapp/DialogScreens/DialogFailed.dart';
import 'package:driverapp/DialogScreens/DialogProcessing.dart';
import 'package:driverapp/DialogScreens/DialogSuccess.dart';

class DriverOptionsPage extends StatefulWidget {
  DriverOptionsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DriverOptionsPageState createState() => _DriverOptionsPageState();
}

class _DriverOptionsPageState extends State<DriverOptionsPage> {
  final GlobalKey<FormState> _formKeySignIn = GlobalKey<FormState>();
  UserDriver userDriver;

  final passwordControllerSignIn = TextEditingController();
  final mobileNumberControllerSignIn = TextEditingController();

  bool rememberMe = true;

  final FocusNode _mobileNumberSignIn = FocusNode();
  final FocusNode _passwordSignIn = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mobileNumberControllerSignIn.dispose();
    passwordControllerSignIn.dispose();
    super.dispose();
  }

  void postSignInRequest(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Sign In", text: "Processing, Please Wait!");
    HTTPHandler().loginDriver([
      mobileNumberControllerSignIn.text,
      passwordControllerSignIn.text,
      rememberMe
    ]).then((value) async {
      if (value[0]) {
        userDriver = value[1];
        Navigator.pop(context);
        DialogSuccess().showCustomDialog(context, title: "Sign In");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(_context, homePageDriver, (route) => false,
            arguments: userDriver);
      } else {
        PostResultOne postResultOne = value[1];
        Navigator.pop(context);
        DialogFailed().showCustomDialog(context,
            title: "Sign In", text: postResultOne.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      Navigator.pop(context);
      DialogFailed()
          .showCustomDialog(context, title: "Sign In", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Stack(children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.3,
              ),
              Text(
                "Welcome Back!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
            ],
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.64,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return Hero(
              tag: 'AnimeBottom',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView(
                    controller: scrollController,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
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
                      Align(
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage('assets/images/logo_black.png'),
                          height: 145.0,
                          width: 145.0,
                        ),
                      ),
                      Material(
                        child: Form(
                          key: _formKeySignIn,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.dialpad),
                                        hintText: "+91",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                    ),
                                    width: 97.0,
                                  ),
                                  SizedBox(width: 16.0),
                                  Flexible(
                                    child: TextFormField(
                                      controller: mobileNumberControllerSignIn,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _mobileNumberSignIn,
                                      onFieldSubmitted: (term) {
                                        _mobileNumberSignIn.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_passwordSignIn);
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Mobile Number",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "This Field is Required";
                                        } else if (value.length != 10) {
                                          return "Enter Valid Mobile Number";
                                        }
                                        return null;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
                                controller: passwordControllerSignIn,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                focusNode: _passwordSignIn,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.vpn_key),
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.amber,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This Field is Required";
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberMe,
                                    checkColor: Colors.white,
                                    activeColor: Color(0xff252427),
                                    onChanged: (bool value) {
                                      setState(() {
                                        rememberMe = value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 0.0,
                                  ),
                                  Text("Remember Me"),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      print("Forgot Password");
                                    },
                                    child: Container(
                                      child: Text("Forgot Password?"),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    if (_formKeySignIn.currentState
                                        .validate()) {
                                      postSignInRequest(context);
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50.0,
                                    child: Center(
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                            color: Color(0xff252427),
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2.0, color: Color(0xff252427)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
