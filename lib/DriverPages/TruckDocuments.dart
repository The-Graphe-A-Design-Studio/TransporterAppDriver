import 'package:driverapp/Models/User.dart';
import 'package:driverapp/MyConstants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class TruckDocuments extends StatefulWidget {
  final UserDriver userDriver;
  final Map docs;

  TruckDocuments({Key key, @required this.userDriver, @required this.docs})
      : super(key: key);
  @override
  _TruckDocumentsState createState() => _TruckDocumentsState();
}

class _TruckDocumentsState extends State<TruckDocuments> {
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
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Owner Name : ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: widget.docs['owner name'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Owner Phone : ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: widget.docs['owner phone'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Truck Number : ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: widget.docs['truck number'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Truck Category : ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: widget.docs['truck category'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Truck Type : ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: widget.docs['truck type'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: Text(
                  'RC : ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 250.0,
                    width: double.infinity,
                    child: PhotoView(
                      maxScale: PhotoViewComputedScale.contained,
                      imageProvider: NetworkImage(
                          'https://truckwale.co.in/${widget.docs['rc']}'),
                      backgroundDecoration: BoxDecoration(color: Colors.white),
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
                        (widget.docs['rc verified'] == '1')
                            ? 'Verified'
                            : 'Not Verified',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: Text(
                  'RTO Passing : ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 250.0,
                    width: double.infinity,
                    child: PhotoView(
                      maxScale: PhotoViewComputedScale.contained,
                      imageProvider: NetworkImage(
                          'https://truckwale.co.in/${widget.docs['rto pass']}'),
                      backgroundDecoration: BoxDecoration(color: Colors.white),
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
                        (widget.docs['rto pass verified'] == '1')
                            ? 'Verified'
                            : 'Not Verified',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: Text(
                  'Road Tax : ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 250.0,
                    width: double.infinity,
                    child: PhotoView(
                      maxScale: PhotoViewComputedScale.contained,
                      imageProvider: NetworkImage(
                          'https://truckwale.co.in/${widget.docs['road tax']}'),
                      backgroundDecoration: BoxDecoration(color: Colors.white),
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
                        (widget.docs['road tax verified'] == '1')
                            ? 'Verified'
                            : 'Not Verified',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: Text(
                  'Insaurance : ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 250.0,
                    width: double.infinity,
                    child: PhotoView(
                      maxScale: PhotoViewComputedScale.contained,
                      imageProvider: NetworkImage(
                          'https://truckwale.co.in/${widget.docs['insurance']}'),
                      backgroundDecoration: BoxDecoration(color: Colors.white),
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
                        (widget.docs['insurance verified'] == '1')
                            ? 'Verified'
                            : 'Not Verified',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
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
            "Truck",
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Truck Documents'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Owner Name : ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: widget.docs['owner name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Owner Phone : ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: widget.docs['owner phone'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Truck Number : ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: widget.docs['truck number'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Truck Category : ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: widget.docs['truck category'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Truck Type : ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: widget.docs['truck type'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                    child: Text(
                      'RC : ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 250.0,
                        width: double.infinity,
                        child: PhotoView(
                          maxScale: PhotoViewComputedScale.contained,
                          imageProvider: NetworkImage(
                              'https://truckwale.co.in/${widget.docs['rc']}'),
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
                            (widget.docs['rc verified'] == '1')
                                ? 'Verified'
                                : 'Not Verified',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                    child: Text(
                      'RTO Passing : ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 250.0,
                        width: double.infinity,
                        child: PhotoView(
                          maxScale: PhotoViewComputedScale.contained,
                          imageProvider: NetworkImage(
                              'https://truckwale.co.in/${widget.docs['rto pass']}'),
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
                            (widget.docs['rto pass verified'] == '1')
                                ? 'Verified'
                                : 'Not Verified',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                    child: Text(
                      'Road Tax : ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 250.0,
                        width: double.infinity,
                        child: PhotoView(
                          maxScale: PhotoViewComputedScale.contained,
                          imageProvider: NetworkImage(
                              'https://truckwale.co.in/${widget.docs['road tax']}'),
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
                            (widget.docs['road tax verified'] == '1')
                                ? 'Verified'
                                : 'Not Verified',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                    child: Text(
                      'Insaurance : ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 250.0,
                        width: double.infinity,
                        child: PhotoView(
                          maxScale: PhotoViewComputedScale.contained,
                          imageProvider: NetworkImage(
                              'https://truckwale.co.in/${widget.docs['insurance']}'),
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
                            (widget.docs['insurance verified'] == '1')
                                ? 'Verified'
                                : 'Not Verified',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            )
          ],
        )
        // Stack(
        //   children: <Widget>[
        //     getCustomWidget(context),
        //     DraggableScrollableSheet(
        //       initialChildSize: 0.65,
        //       minChildSize: 0.4,
        //       maxChildSize: 0.9,
        //       builder: (BuildContext context, ScrollController scrollController) {
        //         return Hero(
        //           tag: 'AnimeBottom',
        //           child: Container(
        //             decoration: BoxDecoration(
        //               color: Colors.white,
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.black,
        //                   blurRadius: 10.0,
        //                 ),
        //               ],
        //               borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(30.0),
        //                 topRight: Radius.circular(30.0),
        //               ),
        //             ),
        //             child: Padding(
        //               padding: EdgeInsets.all(16.0),
        //               child: getDocsBottomSheet(
        //                 context,
        //                 scrollController,
        //               ),
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        //   ],
        // ),
        );
  }
}
