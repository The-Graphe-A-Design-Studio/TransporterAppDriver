import 'package:driverapp/Models/Location.dart';

class Delivery {
  String deliveryIdForTruck;
  String postId;
  String customerId;
  List<Location> sources;
  List<Location> destinations;
  String material;
  var paymentMode;
  String contactPerson;
  String contactPersonPhone;

  Delivery({
    this.deliveryIdForTruck,
    this.postId,
    this.customerId,
    this.sources,
    this.destinations,
    this.material,
    this.paymentMode,
    this.contactPerson,
    this.contactPersonPhone,
  });

  factory Delivery.fromJson(Map<String, dynamic> parsedJson) {
    List<Location> tempS = [];
    for (int i = 0; i < parsedJson['sources'].length; i++)
      tempS.add(Location.fromJson(i + 1, parsedJson['sources'][i]));

    List<Location> tempD = [];
    for (int i = 0; i < parsedJson['destinations'].length; i++)
      tempD.add(Location.fromJson(i + 1, parsedJson['destinations'][i]));

    return Delivery(
      deliveryIdForTruck: parsedJson['delivery id of truck'],
      postId: parsedJson['post id'],
      customerId: parsedJson['customer id'],
      sources: tempS,
      destinations: tempD,
      material: parsedJson['material'],
      paymentMode: parsedJson['payment mode'],
      contactPerson: parsedJson['contact person'],
      contactPersonPhone: parsedJson['contact person phone'],
    );
  }
}
