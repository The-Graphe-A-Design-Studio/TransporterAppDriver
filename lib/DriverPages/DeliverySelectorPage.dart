import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/User.dart';
import 'package:driverapp/MyConstants.dart';
import 'package:flutter/material.dart';

class DeliverySelectorPage extends StatefulWidget {
  final UserDriver user;

  DeliverySelectorPage({Key key, @required this.user}) : super(key: key);

  @override
  _DeliverySelectorPageState createState() => _DeliverySelectorPageState();
}

class _DeliverySelectorPageState extends State<DeliverySelectorPage> {
  List<dynamic> dels;

  @override
  void initState() {
    super.initState();
    print('running');
    HTTPHandler().getNewDel(widget.user.phone).then((value) {
      setState(() {
        this.dels = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliveries'),
      ),
      body: (dels == null)
          ? Center(
              child: Text(
                'No new Deliveries',
                style: TextStyle(color: Colors.white),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: dels
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text('Delivery ID : ${e['delivery id of truck']}'),
                            subtitle: Text('${e['message']}'),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                            ),
                            onTap: () => Navigator.pushNamed(
                              context,
                              deliveriesPage,
                              arguments: [
                                widget.user,
                                e['truck id'],
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
    );
  }
}
