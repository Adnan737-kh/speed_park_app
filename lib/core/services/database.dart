import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/history/car_history_model.dart';
import '../model/location/location_model.dart';
import '../model/newuser/new_user.dart';
import '../model/register_car/car_registration.dart';
import '../model/report_model/report_model.dart';
import '../model/user_request/user_request_car.dart';

List<String> locationAssign = [];
String? userLocation;
String? usernames;

String? selectLocation;
String? totalAmountPerHour;
String? selectChargesPaid;
String? totalAmountTax;
String? amount;
String? perHour;
String? taxCharge;

abstract class SpeedParkDBBase {
  Future<bool> addLocation(Map<String, dynamic> data);
  Future<bool> addReport(Map<String, dynamic> data);
  Future<bool> addNewUser(Map<String, dynamic> data);
  Future<bool> updateReport(String uid, String description);
  Future<bool> updateLocation(
      String uid,  Map<String, dynamic> newData);
  Future<List<ReportModel>> fetchData();
  Stream<List<LocationModel>> getLocationData();
  Stream<List<NewUserModel>> getUserData();
  Future<bool> updateUser(
      String uid, String user, String location, String project,String user_type,String user_location);
  Future<bool> deleteUser(String uid);
  Future<bool> carRegistration(Map<String, dynamic> data);
  Future<List<CarRegistrationModel>> getCarRegisterDataForFilter();
  Future<List<CarRegistrationModel>> getCarRequestData();
  Future<bool> requestCar(Map<String, dynamic> data);
  Future<List<UserCarRequest>> carRequestData();
  Future<bool> deleteRequestFromCarRegistration(String uid);
   Stream<List<CarRegistrationModel>> getCarRegistrations();
  //Stream<Set<CarRegistrationModel>> getCarRegistrations();
  Future<bool> lobbyAndValidationLogin({String? email, String? password,String? usertype});
  Future<bool> updateCarImages(String uid, Map<String,dynamic>data);
  Future<bool> updateCarRequest(
    String uid,
  );
  Future<bool> carHistory(Map<String, dynamic> data);
  Stream<List<CarHistoryModel>> getCarHistory();
  Stream<List<CarHistoryModel>> getCarHistoryForSuperuser();
  Future<bool> guestRequest(String platnumber);
  Future<bool> ticketValidRequest(String ticket,String location);
  Future<bool> validationRequest(String customer,String plateNumber);
}

class DataBaseServices extends SpeedParkDBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add New Location in Database*
  @override
  Future<bool> addLocation(Map<String, dynamic> data) async {
    bool rsp = false;
    var uid = _firestore.collection('Addlocation').doc().id;
    final DataBaseServices _repository = DataBaseServices();    data['uid'] = uid;
    await _firestore
        .collection('Addlocation')
        .doc(uid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  /// Get Data Location From Database*

  @override
  Stream<List<LocationModel>> getLocationData() {
    return _firestore.collection("Addlocation").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        if (data.containsKey("code")) {
          String locationName = data["code"];
          locationAssign.add(locationName);
        }
        return LocationModel.fromMap(data);
      }).toList();
    });
  }


  /// Add Report in Database*
  @override
  Future<bool> addReport(Map<String, dynamic> data) async {
    bool rsp = false;
    var uid = _firestore.collection('report').doc().id;
    data['uid'] = uid;
    await _firestore
        .collection('report')
        .doc(uid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  /// Update Report in Database*
  @override
  Future<bool> updateReport(String uid, String description) async {
    bool rsp = false;
    await _firestore
        .collection('report')
        .doc(uid)
        .update({'description': description})
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  /// Fetch data of Report from Database*
  Future<List<ReportModel>> fetchData() async {
    List<ReportModel> model = [];
    var snapShot = await _firestore.collection("report").get();
    if (snapShot.docs.isNotEmpty) {
      snapShot.docs.forEach((element) {
        ReportModel mdl = ReportModel.fromMap(element.data());

        model.add(mdl);
      });
    }
    return model;
  }

  /// Add New User in Database*
  @override
  Future<bool> addNewUser(Map<String, dynamic> data) async {
    bool rsp = false;
    var uid = _firestore.collection('newuser').doc().id;
    data['uid'] = uid;
    await _firestore
        .collection('newuser')
        .doc(uid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }
  Future<bool> createSuperUser(Map<String, dynamic> data) async {
    bool rsp = false;
    var uid = _firestore.collection('super_users').doc().id;
    data['uid'] = uid;
    await _firestore
        .collection('super_users')
        .doc(uid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  /// Update NewUser in Database*
  @override
  Future<bool>updateUser(String uid, String user, String location, String project,String userType,String user_location) async {
    bool rsp = false;
    await _firestore
        .collection('newuser')
        .doc(uid)
        .update({
          'username': user,
          'email': location,
          'password': project,
          'usertyoe':userType,
          'location':user_location,
        })
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }
  /// Delete userUser in Database*
  @override
  Future<bool>deleteUser(String uid,) async {
    bool rsp = false;
    await _firestore
        .collection('newuser')
        .doc(uid)
        .delete()
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

 /// Delete userUser in Database*
  Future<bool>deleteLocation(String uid,) async {
    bool rsp = false;
    await _firestore
        .collection('Addlocation')
        .doc(uid)
        .delete()
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  /// Fetch Data of user from Firebase*
  // Future<List<NewUserModel>> getUserData() async {
  //   List<NewUserModel> model = [];
  //   try {
  //     var snapShot =
  //         await FirebaseFirestore.instance.collection('newuser').get();
  //     if (snapShot.docs.isNotEmpty) {
  //       snapShot.docs.forEach((element) {
  //         NewUserModel mdl = NewUserModel.fromMap(element.data());
  //
  //         model.add(mdl);
  //       });
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //   }
  //   return model;
  // }
  @override
  Stream<List<NewUserModel>> getUserData() {
    return FirebaseFirestore.instance
        .collection('newuser')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NewUserModel.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  Future<bool> updateLocation(String uid, Map<String, dynamic> newData) async {
    bool rsp = false;
    await _firestore
        .collection('Addlocation')
        .doc(uid)
        .update(newData)
        .then((_) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }


  /// car register in firebase*
  @override
  Future<bool> carRegistration(Map<String, dynamic> data) async {

    // Extract ticket number from the data
    String ticketNumber = data['ticket'];

    print('car reister data $data');
    // Check if a document with the same ticket number already exists
    QuerySnapshot querySnapshot = await _firestore
        // .collection('car_registration')
        .collection('car_registration')
        .where('ticket', isEqualTo: ticketNumber)
        .get();

    bool rsp = false;
    if (querySnapshot.docs.isNotEmpty) {
      // Document with the same ticket number already exists
      if (kDebugMode) {
        print('Car with ticket number $ticketNumber is already registered.');
      }
      // rsp = false;
    } else {
      // Document with the ticket number does not exist, proceed with registration
      try {
        var uid = _firestore.collection('car_registration').doc().id;
        if (kDebugMode) {
          print('${uid}@@@@@@@@@@@@@@@@@');
        }
        data['uid'] = uid;

        await _firestore
            .collection('car_registration')
            .doc(uid)
            .set(data);
        if (kDebugMode) {
          print('✅ Car registered successfully!');
          print('New Document ID: $uid');
          print('Registered Data: $data');
        }

        rsp = true;
      } catch (error) {
        if (kDebugMode) {
          print('Error during car registration: $error');
        }
        rsp = false;
      }
    }
    return rsp;
  }

  /// fetch car register data  from firebase*
  Future<List<CarRegistrationModel>> getCarRegisterData() async {
    List<CarRegistrationModel> model = [];
    try {
      var snapShot =
          await FirebaseFirestore.instance.collection('car_registration').
          where('userlocation', isEqualTo: userLocation)
          .where('request', isEqualTo: false).get();
      if (snapShot.docs.isNotEmpty) {
        snapShot.docs.forEach((element) {
          CarRegistrationModel mdl =
              CarRegistrationModel.fromMap(element.data());

          model.add(mdl);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return model;
  }

  /// fetch car request data  from firebase*
  @override
  Future<List<CarRegistrationModel>> getCarRequestData() async {
    List<CarRegistrationModel> model = [];
    try {
      var snapShot =
          await FirebaseFirestore.instance.collection('car_registration').get();
      if (snapShot.docs.isNotEmpty) {
        snapShot.docs.forEach((element) {
          CarRegistrationModel mdl =
              CarRegistrationModel.fromMap(element.data());

          model.add(mdl);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return model;
  }

  /// fetch car request data  from firebase*
  @override
  Future<bool> requestCar(Map<String, dynamic> data) async {
    bool rsp = false;
    var uid = _firestore.collection('car_request').doc().id;
    print('${uid}@@@@@@@@@@@@@@@@@');
    data['uid'] = uid;
    await _firestore
        .collection('car_request')
        .doc(uid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  @override
  Future<List<UserCarRequest>> carRequestData() async {
    List<UserCarRequest> model = [];
    try {
      var snapShot =
          await FirebaseFirestore.instance.collection('car_request').get();
      if (snapShot.docs.isNotEmpty) {
        snapShot.docs.forEach((element) {
          UserCarRequest mdl = UserCarRequest.fromMap(element.data());

          model.add(mdl);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return model;
  }

  /// delete car registration data  from firebase*
  @override
  Future<bool> deleteRequestFromCarRegistration(String uid) async {
    bool rsp = false;
    await _firestore
        .collection('car_registration')
        .doc(uid)
        .delete()
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  Future<bool> updateCarInParkingUnpaidPaid(String uid) async {
    bool rsp = false;
    await _firestore
        .collection('car_registration')
        .doc(uid)
        .update({'paid_upaid':true,})
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  /// delete car from history data  from firebase*
  Future<bool> deleteCarFromHistory(String uid) async {
    bool rsp = false;
    await _firestore
        .collection('carhistory')
        .doc(uid)
        .delete()
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  @override
  Future<bool> updateCarImages(String uid,Map<String,dynamic>data) async {
    bool rsp = false;
    await _firestore
        .collection('car_registration')
        .doc(uid)
        .update(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  @override
  Future<bool> updateCarRequest(
    String uid,
  ) async {
    bool rsp = false;
    await _firestore
        .collection('car_registration')
        .doc(uid)
        .update({'request': true})
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }

  @override
  Stream<List<CarRegistrationModel>> getCarRegistrations() {
    List<CarRegistrationModel> retVal = [];
    return FirebaseFirestore.instance
        .collection('car_registration')
        .where('userlocation', isEqualTo: userLocation)
        .where('request', isEqualTo: false)
        .orderBy('ticket')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      retVal.clear();
      List<Map<String, dynamic>> dataList = [];

      for (var element in querySnapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        dataList.add(data);
      }

      dataList.sort((a, b) {
        int aTicket = int.tryParse(a['ticket'] as String) ?? 0;
        int bTicket = int.tryParse(b['ticket'] as String) ?? 0;

        return aTicket.compareTo(bTicket);
      });

      for (var data in dataList) {
        retVal.add(CarRegistrationModel.fromMap(data));
      }

      if (kDebugMode) {
        print('success');
      }
      return retVal;
    }).handleError((error) {
      log("Error fetching car registrations: $error");
      return [];
    });
  }

  Stream<List<CarRegistrationModel>> getCarRequests() {
    if (kDebugMode) {
      print('user loc@@@ $userLocation');
    }
    return FirebaseFirestore.instance
        .collection('car_registration')
        .where('request',isEqualTo: true)
        .where('userlocation',isEqualTo: userLocation)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<CarRegistrationModel> retVal = [];

      for (var element in querySnapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        if (kDebugMode) {
          print('getCarRequests data $data');
        }
        retVal.add(CarRegistrationModel.fromMap(data));
      }
      return retVal;
    }).handleError((error) {
      // Handle error here if needed
      if (kDebugMode) {
        print("Error fetching car requests: $error");
      }
      // Returning an empty list to avoid returning null
      return [];
    });
  }

  @override
  Future<bool> lobbyAndValidationLogin({String? email, String? password,String? usertype}) async {
    print('data@@@@ $email, $password $usertype' );
    bool rsp = false;
    var snapShot = await _firestore
        .collection("newuser")
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .where('usertyoe', isEqualTo: usertype)
        .get();

    if (snapShot.docs.isNotEmpty) {
      snapShot.docs.forEach((element) {
        Map<String, dynamic> data = element.data();
        if (data.containsKey("location")) {
          print('again call');
          String locationName = data["location"];
          String username = data["username"];
          userLocation = locationName.toString();
          usernames = username.toString();
          print('call $locationName');
        }
      }); // Close the forEach block here
      rsp = true;
    }
    return rsp;
  }

  Future<bool> superUserLogin({String? email, String? password,String? usertype}) async {
    bool rsp = false;
    var snapShot = await _firestore
        .collection("super_users")
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .where('userType', isEqualTo: usertype)
        .get();

    if (snapShot.docs.isNotEmpty) {
      snapShot.docs.forEach((element) {
        Map<String, dynamic> data = element.data();
        if (data.containsKey("location")) {
          String locationName = data["location"];
          String username = data["username"];
          userLocation = locationName.toString();
          usernames = username.toString();
        }
      }); // Close the forEach block here
      rsp = true;
    }
    return rsp;
  }


  /// Add New Car History in Database*
  @override
  Future<bool> carHistory(Map<String, dynamic> data) async {
    bool rsp = false;
    try {
      var uid = _firestore.collection('carhistory').doc().id;

      if (kDebugMode) {
        debugPrint('Generated Firestore Document UID: $uid');
      }

      data['uid'] = uid;

      await _firestore
          .collection('carhistory')
          .doc(uid)
          .set(data)
          .then((_) {
        rsp = true;
        if (kDebugMode) {
          debugPrint('✅ carHistory: Document written successfully');
        }
      })
          .onError((error, stackTrace) {
        rsp = false;
        if (kDebugMode) {
          debugPrint('❌ carHistory: Firestore error occurred');
          debugPrint('Error: $error');
          debugPrintStack(stackTrace: stackTrace);
        }
      });

    } catch (e, st) {
      rsp = false;
      if (kDebugMode) {
        debugPrint('❌ carHistory: Exception caught');
        debugPrint('Exception: $e');
        debugPrintStack(stackTrace: st);
      }
    }

    return rsp;
  }


  Future<bool> updateCarInHistory(String uid,Map<String,dynamic>data) async {
    bool rsp = false;
    await _firestore
        .collection('carhistory')
        .doc(uid)
        .update(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }


  @override
  Stream<List<CarHistoryModel>> getCarHistory() {
    return FirebaseFirestore.instance
        .collection('carhistory')
        .where('user_location', isEqualTo: userLocation)
        .orderBy('orderbytime', descending: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<CarHistoryModel> retVal = [];

      for (var element in querySnapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        try {
          retVal.add(CarHistoryModel.fromMap(data));
        } catch (e) {
          print("Error converting document to CarHistoryModel: $e");
        }
      }
      return retVal;
    })
        .handleError((error) {
      print("Error fetching car requests: $error");
      return [];
    });
  }

  @override
  Stream<List<CarHistoryModel>> getCarHistoryForSuperuser() {
    return FirebaseFirestore.instance
        .collection('carhistory')
        .where('location_type_check',isEqualTo: 'Paid')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<CarHistoryModel> retVal = [];

      for (var element in querySnapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        retVal.add(CarHistoryModel.fromMap(data));
      }
      return retVal;
    }).handleError((error) {
      // Handle error here if needed
      print("Error fetching car requests: $error");
      // Returning an empty list to avoid returning null
      return [];
    });
  }
/// Guest Request For Car
  @override
  Future<bool> guestRequest(String plateNumber) async{
    bool rsp = false;
    // Find documents with the matching plate number and request is false
    final querySnapshot = await _firestore
        .collection('car_registration')
        .where('platenumber', isEqualTo: plateNumber)
        .where('request', isEqualTo: false)
        .get();
    // Update the request status for matching documents
    for (final docSnapshot in querySnapshot.docs) {
      final docReference = docSnapshot.reference;
      await docReference.update({
        'request': true,
        // You can update other fields here if needed
      }).then((v) => rsp = true)
          .onError((error, stackTrace) => rsp = false);
    }


    return rsp;
  }
  /// Guest Request For Car Again
  Future<bool> againGuestRequest(String plateNumber,ticketNumber) async{
    bool rsp = false;
    // Find documents with the matching plate number and request is false
    final querySnapshot = await _firestore
        .collection('car_registration')
        .where('platenumber', isEqualTo: plateNumber)
        .where('ticket', isEqualTo: ticketNumber)
        .where('request', isEqualTo: true)
        .get();
    // Update the request status for matching documents
    for (final docSnapshot in querySnapshot.docs) {
      final docReference = docSnapshot.reference;
      await docReference.update({
        'request': true,
        // You can update other fields here if needed
      }).then((v) => rsp = true)
          .onError((error, stackTrace) => rsp = false);
    }


    return rsp;
  }
  Future<bool> updateCarInParkingRequest(String uid,String amount) async {
    bool rsp = false;
    await _firestore
        .collection('car_registration')
        .doc(uid)
        .update({
      'request':true,
      'loby_request':false,
      'amount':amount,
      'totalamounttax':amount})
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);
    return rsp;
  }



  @override
  Future<bool> ticketValidRequest(String ticket,String location) async{
    bool rsp = false;
    // Find documents with the matching plate number and request is false
    final querySnapshot = await _firestore
        .collection('car_registration')
        .where('ticket', isEqualTo: ticket)
        .where('username', isEqualTo: location)
        .get();
    // Update the request status for matching documents
    for (final docSnapshot in querySnapshot.docs) {
      final docReference = docSnapshot.reference;
      await docReference.update({
        'ticket_valid': true,
        // 'location_type_check': 'Validated',
        // 'request':true,
        // 'loby_request':true,
      }).then((v) => rsp = true)
          .onError((error, stackTrace) => rsp = false);
    }
    return rsp;
  }


  /// Validation Request For Car
  @override
  Future<bool> validationRequest(String ticket, String plateNumber) async {
    bool rsp = false;

    Query query = _firestore.collection('car_registration');

    if (ticket != 'no') {
      query = query.where('ticket', isEqualTo: ticket);
    }

    if (plateNumber!='no') {
      query = query.where('platenumber', isEqualTo: plateNumber);
    }

    query = query.where('request', isEqualTo: false);

    final querySnapshot = await query.get();

    for (final docSnapshot in querySnapshot.docs) {
      final docReference = docSnapshot.reference;

      await docReference.update({
        'request': true,
        'validationrequestby':true,
        'username':usernames,
        'location_type_check':'Validated',
        // You can update other fields here if needed
      }).then((_) => rsp = true).onError((_, __) => rsp = false);
    }

    return rsp;
  }

  @override
  Future<bool> againValidationRequest(String ticket,String plateNumber) async{
    bool rsp = false;
    // Find documents with the matching plate number and request is false
    Query query = _firestore.collection('car_registration');
    print('$ticket and $plateNumber');

    if (ticket !='no') {
      query = query.where('ticket', isEqualTo: ticket);
      print('$ticket and $plateNumber and qurery of ticket $query');
    }

    if (plateNumber!='no') {
      query = query.where('platenumber', isEqualTo: plateNumber);
      print('$ticket and $plateNumber and qurery of platenumber $query');
    }

    query = query.where('request', isEqualTo: true);

    final querySnapshot = await query.get();

    for (final docSnapshot in querySnapshot.docs) {
      final docReference = docSnapshot.reference;

      await docReference.update({
        'request': true,
        'validationrequestby':true,
        // You can update other fields here if needed
      }).then((_) => rsp = true).onError((_, __) => rsp = false);
    }


    return rsp;
  }
  /// Validation Request For Car End

/// Validation Ticket Number End
/// Fetch Selected Location Data

  Future<bool> fetchDataForSelectedLocation(String selectedLocation) async {
    bool rsp = false;
    try {
      var snapshot = await _firestore
          .collection("Addlocation")
          .where("code", isEqualTo: selectedLocation)
          .get();

      if (snapshot.docs.isNotEmpty) {

        var data = snapshot.docs[0].data(); // Assuming there is only one document with a matching location code

          // Populate other fields with data retrieved from Firestore
        totalAmountPerHour = data["totalamountperhour"];
          totalAmountTax = data["totoalamountwithtax"];
        selectLocation = data["selectLocation"];
        selectChargesPaid = data["selectCharges"];

       amount=data['amount'];
       perHour=data['perhour'];
        taxCharge=data['taxCharge'];
        rsp=true;
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return rsp;
  }



/// Fetch Selected Location Data End
///
///
/// New Find Compleete Collection

  Future<Map<String, double>> calculateCollectionForLocations(List<String> locations_get) async {
    Map<String, double> locationCollectionMap = {};
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('car_registration');

    for (String location in locations_get) {
      try {
        double totalCollection = 0.0;

        QuerySnapshot snapshot = await collectionReference
            .where('userlocation', isEqualTo: location)
            .where('selectLocation', isEqualTo: 'Paid')
            .get();

        snapshot.docs.forEach((doc) {
          var amount = doc['amount'];

          // Check if 'amount' is a number or a string that can be parsed to a number
          if (amount is num || (amount is String && double.tryParse(amount) != null)) {
            totalCollection += num.parse(amount);
          } else {
            print('Warning: Amount for $location is not a valid number.');
          }
        });

        locationCollectionMap[location] = totalCollection;
        print('Total collection for $location: $totalCollection AED');
      } catch (e) {
        print('Error querying Firestore for $location: $e');
      }
    }

    return locationCollectionMap;
  }



  Future<String> fetchCarDetails(String driveName) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('car_registration')
          .where('driver', isEqualTo: driveName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<String> carDetailsList = [];

        for (QueryDocumentSnapshot doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          var carPlateNumber = data['platenumber'];
          var ticketNumber = data['ticket'];
          var carRegisterdate = data['date'];
          var carRegisterTime = data['time'];

          if (carPlateNumber != null && ticketNumber != null && carRegisterTime != null&& carRegisterdate != null) {
            carDetailsList.add(
              'Car Plate Number: $carPlateNumber\nTicket Number: $ticketNumber\nRegister Date: $carRegisterdate\n Register Time: $carRegisterTime',
            );
          } else {
            return 'Data is incomplete for drive name: $driveName';
          }
        }

        if (carDetailsList.isNotEmpty) {
          return carDetailsList.join('\n\n');
        } else {
          return 'No car found for drive name: $driveName';
        }
      } else {
        return 'No car found for drive name: $driveName';
      }
    } catch (e) {
      print('Error fetching car details: $e');
      return 'Error fetching car details';
    }
  }

  @override
  Future<List<CarRegistrationModel>> getCarRegisterDataForFilter() async{
    List<CarRegistrationModel> model = [];
    var snapShot = await _firestore.collection("car_registration").get();
    if (snapShot.docs.isNotEmpty) {
      snapShot.docs.forEach((element) {
        CarRegistrationModel mdl = CarRegistrationModel.fromMap(element.data());

        model.add(mdl);
      });
    }
    return model;
  }




}
