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
                child: Text(
                  'RC : ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
              SizedBox(
                height: 16.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: Text(
                  'RTO Passing : ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
              SizedBox(
                height: 16.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: Text(
                  'Road Tax : ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
              SizedBox(
                height: 16.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, bottom: 20.0),
                child: Text(
                  'Insaurance : ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
