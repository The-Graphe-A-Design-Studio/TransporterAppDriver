import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriverOptionsPage extends StatefulWidget {
  DriverOptionsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DriverOptionsPageState createState() => _DriverOptionsPageState();
}

enum WidgetMarker { options, credentials, documents }

class _DriverOptionsPageState extends State<DriverOptionsPage> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.options;
  WidgetMarker selectedBottomSheetWidgetMarker = WidgetMarker.options;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FocusNode _name = FocusNode();
  final FocusNode _mobileNumber = FocusNode();
  final FocusNode _email = FocusNode();
  final FocusNode _password = FocusNode();
  final FocusNode _confirmPassword = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget getOptionsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(
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
                  color: Colors.black,
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
        Align(
          alignment: Alignment.center,
          child: Material(
            child: Text("Welcome to Some App."),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Material(
            child: Text("Intro Content Intro Content"),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Material(
            child: Text("Intro Content"),
          ),
        ),
        SizedBox(height: 40.0),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                selectedWidgetMarker = WidgetMarker.credentials;
                selectedBottomSheetWidgetMarker = WidgetMarker.credentials;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50.0,
              child: Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2.0, color: Colors.black),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => print("Sign In"),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50.0,
              child: Center(
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2.0, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getCredentialsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.options;
                            selectedBottomSheetWidgetMarker =
                                WidgetMarker.options;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.options;
                            selectedBottomSheetWidgetMarker =
                                WidgetMarker.options;
                          });
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Colors.black12,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                focusNode: _name,
                onFieldSubmitted: (term) {
                  _name.unfocus();
                  FocusScope.of(context).requestFocus(_mobileNumber);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "Full Name",
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
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: mobileNumberController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _mobileNumber,
                onFieldSubmitted: (term) {
                  _mobileNumber.unfocus();
                  FocusScope.of(context).requestFocus(_email);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.dialpad),
                  hintText: "Policy Number",
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
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _email,
                onFieldSubmitted: (term) {
                  _email.unfocus();
                  FocusScope.of(context).requestFocus(_password);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  hintText: "Email",
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
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                focusNode: _password,
                onFieldSubmitted: (term) {
                  _password.unfocus();
                  FocusScope.of(context).requestFocus(_confirmPassword);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                focusNode: _confirmPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.timer),
                  hintText: "Confirm Password",
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
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      selectedWidgetMarker = WidgetMarker.documents;
                      selectedBottomSheetWidgetMarker = WidgetMarker.documents;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget getDocumentsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.credentials;
                            selectedBottomSheetWidgetMarker =
                                WidgetMarker.credentials;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.options;
                            selectedBottomSheetWidgetMarker =
                                WidgetMarker.options;
                          });
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Colors.black12,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.picture_as_pdf),
                  suffixIcon: Icon(
                    Icons.add_box,
                    size: 35.0,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  hintText: "Upload RC Book",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  suffixIcon: Icon(
                    Icons.add_box,
                    size: 35.0,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  hintText: "Upload Driver's License",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _email,
                onFieldSubmitted: (term) {
                  _email.unfocus();
                  FocusScope.of(context).requestFocus(_password);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  hintText: "Email",
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
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                focusNode: _password,
                onFieldSubmitted: (term) {
                  _password.unfocus();
                  FocusScope.of(context).requestFocus(_confirmPassword);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                focusNode: _confirmPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.timer),
                  hintText: "Confirm Password",
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
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      selectedWidgetMarker = WidgetMarker.documents;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget getOptionsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100.0,
          ),
          Text(
            "Hi, User",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget getCredentialsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
          ),
          Text(
            "Credentials",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget getDocumentsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
          ),
          Text(
            "Documents",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget getCustomWidget(context) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.options:
        return getOptionsWidget(context);
      case WidgetMarker.credentials:
        return getCredentialsWidget(context);
      case WidgetMarker.documents:
        return getDocumentsWidget(context);
    }
    return getOptionsWidget(context);
  }

  Widget getCustomBottomSheetWidget(
      context, ScrollController scrollController) {
    switch (selectedBottomSheetWidgetMarker) {
      case WidgetMarker.options:
        return getOptionsBottomSheetWidget(context, scrollController);
      case WidgetMarker.credentials:
        return getCredentialsBottomSheetWidget(context, scrollController);
      case WidgetMarker.documents:
        return getDocumentsBottomSheetWidget(context, scrollController);
    }
    return getOptionsBottomSheetWidget(context, scrollController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: <Widget>[
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
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: getCustomBottomSheetWidget(
                            context, scrollController),
                      )));
            },
          ),
        ]));
  }
}
