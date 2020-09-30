class UserDriver {
  bool success;
  String id;
  String name;
  String phoneCode;
  String phone;
  String pic;
  String license;
  String truckOwnerId;
  String truchNumber;
  String truckCategory;
  String truckType;
  String truckRc;
  String truckInsaurance;
  String truckRoadTax;
  String truchRTOPassing;
  String firebaseToken;

  UserDriver({
    this.success,
    this.id,
    this.name,
    this.phoneCode,
    this.phone,
    this.pic,
    this.license,
    this.truckOwnerId,
    this.truchNumber,
    this.truckCategory,
    this.truckType,
    this.truckRc,
    this.truckInsaurance,
    this.truckRoadTax,
    this.truchRTOPassing,
    this.firebaseToken,
  });

  factory UserDriver.fromJson(Map<String, dynamic> parsedJson) {
    return UserDriver(
      success: parsedJson['success'] == '1' ? true : false,
      id: parsedJson['id'],
      name: parsedJson['driver name'],
      phoneCode: parsedJson['phone country code'],
      phone: parsedJson['driver phone'],
      pic: parsedJson['driver pic'],
      license: parsedJson['driver license'],
      truckOwnerId: parsedJson['truck owner id'],
      truchNumber: parsedJson['truck number'],
      truckCategory: parsedJson['truck category'],
      truckType: parsedJson['truck type'],
      truckRc: parsedJson['truck rc'],
      truckInsaurance: parsedJson['truck insurance'],
      truckRoadTax: parsedJson['truck road tax'],
      truchRTOPassing: parsedJson['truck rto passing'],
      firebaseToken: parsedJson['firebase token'],
    );
  }
}
