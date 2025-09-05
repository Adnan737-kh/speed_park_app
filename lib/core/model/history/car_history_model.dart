class CarHistoryModel {
  String? platNumber;
  String? registerDate;
  String? deliveredDate;
  String? uid;
  String? deliveredTime;
  String? registerTime;
  String? locationTypeCheck;
  String? selectCharges;
  String? taxInclude;
  String? amountIncludeTax;
  String? perHour;
  String? taxCharge;
  String? userLocation;
  String? carMade;
  String? model;
  String? carType;
  String? color;
  String? owner;
  String? mobileNumber;
  String? recordDamage;
  String? floorNumber;
  String? parkingNumber;
  String? ticketNumber;
  String? driverName;
  String? validatorName;
  int? orderByTime;
  bool? validationRequestedBy;
  String? isCarPaidOrValidated;
  List<dynamic>? images;
  String? driverReceive;

  CarHistoryModel({
    this.platNumber,
    this.registerDate,
    this.deliveredDate,
    this.uid,
    this.deliveredTime,
    this.registerTime,
    this.locationTypeCheck,
    this.selectCharges,
    this.taxInclude,
    this.amountIncludeTax,
    this.perHour,
    this.taxCharge,
    this.userLocation,
    this.carMade,
    this.model,
    this.carType,
    this.color,
    this.owner,
    this.mobileNumber,
    this.recordDamage,
    this.floorNumber,
    this.parkingNumber,
    this.ticketNumber,
    this.driverName,
    this.driverReceive,
    this.orderByTime,
    this.validatorName,
    this.validationRequestedBy,
    this.isCarPaidOrValidated,
    this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'platnumber': platNumber,
      'register_date': registerDate,
      'delivered_date': deliveredDate,
      'uid': uid,
      'delivered_time': deliveredTime,
      'register_time': registerTime,
      'location_type_check': locationTypeCheck,
      'select_charges': selectCharges,
      'tax_include': taxInclude,
      'amount_include_tax': amountIncludeTax,
      'perhour': perHour,
      'taxCharge': taxCharge,
      'user_location': userLocation,
      'carmade': carMade,
      'model': model,
      'car_type': carType,
      'color': color,
      'owner': owner,
      'mobile_number': mobileNumber,
      'record_damage': recordDamage,
      'floornumber': floorNumber,
      'parking_number': parkingNumber,
      'ticket_number': ticketNumber,
      'driver_name': driverName,
      'driver_recive': driverReceive,
      'orderbytime': orderByTime,
      'username': validatorName,
      'validationrequestby': validationRequestedBy,
      'isCarPaidOrValidated': isCarPaidOrValidated,
      'images': images,
    };
  }

  factory CarHistoryModel.fromMap(Map<String, dynamic> map) {
    return CarHistoryModel(
      platNumber: map['platnumber'] as String?,
      registerDate: map['register_date'] as String?,
      deliveredDate: map['delivered_date'] as String?,
      uid: map['uid'] as String?,
      deliveredTime: map['delivered_time'] as String?,
      registerTime: map['register_time'] as String?,
      locationTypeCheck: map['location_type_check'] as String?,
      selectCharges: map['select_charges'] as String?,
      taxInclude: map['tax_include'] as String?,
      amountIncludeTax: map['amount_include_tax'] as String?,
      perHour: map['perhour'] as String?,
      taxCharge: map['taxCharge'] as String?,
      userLocation: map['user_location'] as String?,
      carMade: map['carmade'] as String?,
      model: map['model'] as String?,
      carType: map['car_type'] as String?,
      color: map['color'] as String?,
      owner: map['owner'] as String?,
      mobileNumber: map['mobile_number'] as String?,
      recordDamage: map['record_damage'] as String?,
      floorNumber: map['floornumber'] as String?,
      parkingNumber: map['parking_number'] as String?,
      ticketNumber: map['ticket_number'] as String?,
      driverName: map['driver_name'] as String?,
      driverReceive: map['driver_recive'] as String?,
      orderByTime: map['orderbytime'] as int?,
      validatorName: map['username'] as String?,
      isCarPaidOrValidated: map['isCarPaidOrValidated'] as String?,
      images: map['images'] as List<dynamic>?,
    );
  }
}
