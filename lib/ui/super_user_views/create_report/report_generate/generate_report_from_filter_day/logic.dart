import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import '../../../../../core/model/history/car_history_model.dart';
import '../../../../../core/model/register_car/car_registration.dart';
import '../../../../../core/services/database.dart';
import '../../../../lobby_controller_views/request_a_car/logic.dart';
import '../../logic.dart';
import 'state.dart';

final homeScreen = Get.put(CreateReportLogic());

//enum LocationType { all, paid, normal }
class GenerateReportFromFilterLogicDay extends GetxController {
  final GenerateReportFromFilterLogicDayState state =
      GenerateReportFromFilterLogicDayState();
  String selectedLocation = 'All Locations';
  //LocationType selectedLocationType = LocationType.all;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TextEditingController driverNameController = TextEditingController();
  List<String> locationType = ['Normal', 'Paid'];

  final List<CarRegistrationModel> _car = [];
  List<CarRegistrationModel> get car => _car;
  final DataBaseServices _repository = DataBaseServices();
  List<CarHistoryModel> filteredCarList = [];
  Future<void> fetchData() async {
    try {
      _car.clear();
      final data = await _repository.getCarRegisterDataForFilter();
      _car.addAll(data);
      //_car.add('All');
      if (kDebugMode) {
        print('${_car.length}');
      }
      update();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  String? selectLocationType;
  void updateLocationType(value) {
    selectLocationType = value;
    update();
  }

  Future<void> selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      startDate = picked;
    }
    update();
  }

  Future<void> selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != endDate) {
      endDate = picked;
    }
    update();
  }

  filterData() async {
    final String dateFormat = DateFormat('MMM d, y').format(startDate);
    final String endFormatDate = DateFormat('MMM d, y').format(endDate);
    //String formattedDate = DateFormat('MMM d, y').format(dateTime);

    try {
      if (homeScreen.selectLocation == 'All') {
        print('All select charges');
        QuerySnapshot<
            Map<String,
                dynamic>> querySnapshot = await FirebaseFirestore.instance
            .collection('carhistory')
            .where('location_type_check', isEqualTo:
        selectLocationType == 'Normal'
            ? selectLocationType : selectLocationType == 'Paid'
            ? selectLocationType : null)
            .where('register_date', isEqualTo: dateFormat)
                    .get();

        filteredCarList = querySnapshot.docs
            .map((carDoc) => CarHistoryModel.fromMap(carDoc.data()))
            .toList();
      } else {
        if (kDebugMode) {
          print('Not All select charges');
        }
        QuerySnapshot<
            Map<String,
                dynamic>> querySnapshot = await FirebaseFirestore.instance
            .collection('carhistory')
            .where('location_type_check',
                isEqualTo: selectLocationType == 'Normal'
                    ? selectLocationType
                    : selectLocationType == 'Paid'
                        ? selectLocationType
                        : null)
            .where('user_location', isEqualTo: homeScreen.selectLocation)
            .where('register_date', isEqualTo: dateFormat).get();

        filteredCarList = querySnapshot.docs
            .map((carDoc) => CarHistoryModel.fromMap(carDoc.data()))
            .toList();
      }

      if (kDebugMode) {
        print(
            ' check pick location is : ${homeScreen.selectLocation == 'ALL' ? null : homeScreen.selectLocation}');
        print(' check pick location is : $dateFormat$endFormatDate');
      }

      update();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching filtered data: $e');
      }
    }
  }

  deleteCar(String uid) async {
    bool confirmed = await showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this car?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false if user cancels
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true if user confirms
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ProgressDialog progressDialog = ProgressDialog(
        Get.context!,
        blur: 10,
        title: const Text("Car Deleting"),
        message: const Text("Please Wait"),
        onDismiss: () {
          if (kDebugMode) {
            debugPrint("Do something onDismiss");
          }
        },
      );
      progressDialog.show();

      try {
        final resp =
            await DataBaseServices().deleteCarFromHistory(uid.toString());

        if (resp) {
          progressDialog.dismiss();
          confirm.carRemoveFromConfirm(index: 1);
          update(); // Update UI after successful deletion
        } else {
          throw Exception('Failed to Delete a car in parking request');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error while updating car in parking request: $e');
        }
        progressDialog
            .dismiss(); // Dismiss the ProgressDialog in case of an error
        // Handle the error gracefully, e.g., show an error message to the user
      }
    }
  }
}
