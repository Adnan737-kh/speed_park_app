class CarRegistrationModel {
  String? uid;
  String? time;
  String? carMade;
  String? model;
  String? carType;
  String? color;
  String? owner;
  String? mobileNumber;
  String? recordDamage;
  String? floorNumber;
  String? parkingNumber;
  String? plateNumber;
  String? userId;
  String? uniqueId;
  String? date;
  bool? request;
  List? images;
  String? userLocation;
  String? validationUserName;
  String? ticket;
  bool? ticketValid;
  String? selectLocation;
  String? totalAmountPerHour;
  String? totalAmountTax;
  String? selectCharges;
  String? amount;
  String? perHour;
  String? taxCharge;
  bool? validationRequestBy;
  bool? lobbyRequest;
  String? driverName;
  int? orderByTime;
  bool? paidUnPaid;

  CarRegistrationModel(
      {this.uid,
      this.time,
      this.carMade,
      this.model,
      this.carType,
      this.color,
      this.owner,
      this.mobileNumber,
      this.recordDamage,
      this.floorNumber,
      this.parkingNumber,
      this.plateNumber,
      this.userId,
      this.uniqueId,
      this.date,
      this.request,
      this.images,
      this.userLocation,
      this.validationUserName,
      this.ticket,
      this.ticketValid,
      this.selectLocation,
      this.totalAmountPerHour,
      this.selectCharges,
      this.totalAmountTax,
        this.orderByTime,
        this.paidUnPaid,
      this.amount,this.perHour,this.taxCharge,this.validationRequestBy,this.lobbyRequest,
        this.driverName});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'time': this.time,
      'carmade': this.carMade,
      'model': this.model,
      'car_type': this.carType,
      'color': this.color,
      'owner': this.owner,
      'mobile_number': this.mobileNumber,
      'record_damage': this.recordDamage,
      'floornumber': this.floorNumber,
      'parking_number': this.parkingNumber,
      'platenumber': this.plateNumber,
      'user_id': this.userId,
      'uinque_id': this.uniqueId,
      'date': this.date,
      'request': this.request,
      'images': this.images,
      'username': this.validationUserName,
      'userlocation': this.userLocation,
      'ticket': this.ticket,
      'ticket_valid': ticketValid,
      'selectLocation': selectLocation,
      'totalamountperhour': totalAmountPerHour,
      'selectCharges': selectCharges,
      'totalamounttax': totalAmountTax,
      'amount': amount,
      'perhour':perHour,
      'taxCharge':taxCharge,
      'validationrequestby':validationRequestBy,
      'loby_request':lobbyRequest,
      'driver':driverName,
      'orderbytime':orderByTime,
      'paid_upaid':paidUnPaid,

    };
  }

  factory CarRegistrationModel.fromMap(Map<String, dynamic> map) {
    return CarRegistrationModel(
      uid: map['uid'] ?? '',
      time: map['time'] ?? '',
      carMade: map['carmade'] ?? '',
      model: map['model'] ?? '',
      carType: map['car_type'] ?? '',
      color: map['color'] ?? '',
      owner: map['owner'] ?? '',
      mobileNumber: map['mobile_number'] ?? '',
      recordDamage: map['record_damage'] ?? '',
      floorNumber: map['floornumber'] ?? '',
      parkingNumber: map['parking_number'] ?? '',
      plateNumber: map['platenumber'] ?? '',
      userId: map['user_id'] ?? '',
      uniqueId: map['uinque_id'] ?? '',
      date: map['date'] ?? '',
      request: map['request'] ?? false,
      images: map['images'] ?? [],
      validationUserName: map['username'] ?? '',
      userLocation: map['userlocation'] ?? '',
      ticket: map['ticket'] ?? '',
      ticketValid: map['ticket_valid'],
      selectLocation: map['selectLocation'],
      totalAmountPerHour: map['totalamountperhour'],
      selectCharges: map['selectCharges'],
      totalAmountTax: map['totalamounttax'],
      amount: map['amount'],
      perHour: map['perhour'],
      taxCharge:map['taxCharge'],
      validationRequestBy:map['validationrequestby'],
      lobbyRequest:map['loby_request'],
      driverName:map['driver'],
      orderByTime:map['orderbytime'],
      paidUnPaid:map['paid_upaid'],
    );
  }
}
