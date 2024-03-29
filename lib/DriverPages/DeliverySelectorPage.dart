import 'package:driverapp/HttpHandler.dart';
import 'package:driverapp/Models/User.dart';
import 'package:driverapp/MyConstants.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DeliverySelectorPage extends StatefulWidget {
  final UserDriver user;

  DeliverySelectorPage({Key key, @required this.user}) : super(key: key);

  @override
  _DeliverySelectorPageState createState() => _DeliverySelectorPageState();
}

class _DeliverySelectorPageState extends State<DeliverySelectorPage> {
  List<dynamic> dels;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(BuildContext context) async {
    print('working properly');
    getDeliveries();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  getDeliveries() {
    HTTPHandler().getNewDel(widget.user.phone).then((value) {
      setState(() {
        this.dels = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print('running');
    getDeliveries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Deliveries'),
      ),
      body: (dels == null)
          ? SmartRefresher(
              controller: _refreshController,
              onRefresh: () => _onRefresh(context),
              child: Center(
                child: Text(
                  'No new Deliveries',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : SmartRefresher(
              controller: _refreshController,
              onRefresh: () => _onRefresh(context),
              child: SingleChildScrollView(
                child: Column(
                  children: dels
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              color: Colors.black87,
                              padding: const EdgeInsets.all(0.5),
                              child: ListTile(
                                tileColor: Colors.white,
                                title: Text(
                                    'Delivery ID : ${e['delivery id of truck']}'),
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
                                    e['delivery id of truck'],
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
    );
  }
}
