
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/model/history/car_history_model.dart';
import '../../../../../core/model/register_car/car_registration.dart';
import '../../../../../core/services/database.dart';
import '../../logic.dart';
import 'state.dart';
final homescreen = Get.put(CreateReportLogic());
//enum LocationType { all, paid, normal }
class Generate_report_from_filterLogic extends GetxController {


  final Generate_report_from_filterState state = Generate_report_from_filterState();
  String selectedLocation = 'All Locations';
  //LocationType selectedLocationType = LocationType.all;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TextEditingController driverNameController = TextEditingController();
  List<String> locationType = ['Normal','Paid'];

  final List<CarRegistrationModel> _car=[];
  List<CarRegistrationModel> get car => _car;
  final DataBaseServices _repository = DataBaseServices();
  List<CarHistoryModel> filteredCarList = [];
  Future<void> fetchData() async {
    try {
      _car.clear();
      final data = await _repository.getCarRegisterDataForFilter();
      _car.addAll(data);
      //_car.add('All');
      print('${_car.length}');
      update();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();

  }


  String? selectlocationType;
  void updatelocationType(value) {
    selectlocationType = value;
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
    final String endformatdate = DateFormat('MMM d, y').format(endDate);
    //String formattedDate = DateFormat('MMM d, y').format(dateTime);

    try {
      if(homescreen.selectLocation == 'All') {
        print('All select charges');
        QuerySnapshot<
            Map<String, dynamic>> querySnapshot = await FirebaseFirestore
            .instance
            .collection('carhistory')
            .where('location_type_check',
            isEqualTo: selectlocationType == 'Normal'
                ? selectlocationType
                : selectlocationType == 'Paid' ? selectlocationType : null)
            // .where('user_location',
            // isEqualTo: homescreen.selectCharges == 'All' ? null : homescreen
            //     .selectCharges)
            .where('register_date', isGreaterThanOrEqualTo: dateFormat)
            .where('register_date', isLessThanOrEqualTo: endformatdate)
        //.where('driver',isEqualTo:driverNameController.text==null?null:driverNameController.text.toString().toLowerCase() )
            .get();

        filteredCarList = querySnapshot.docs
            .map((carDoc) => CarHistoryModel.fromMap(carDoc.data() as Map<String, dynamic>))
            .toList();
      }else{
        if (kDebugMode) {
          print('Not All select charges');
        }
        QuerySnapshot<
            Map<String, dynamic>> querySnapshot = await FirebaseFirestore
            .instance
            .collection('carhistory')
            .where('location_type_check',
            isEqualTo: selectlocationType == 'Normal'
                ? selectlocationType
                : selectlocationType == 'Paid' ? selectlocationType : null)
        .where('user_location',
        isEqualTo:  homescreen.selectLocation)
            .where('register_date', isGreaterThanOrEqualTo: dateFormat)
            .where('register_date', isLessThanOrEqualTo: endformatdate)
        //.where('driver',isEqualTo:driverNameController.text==null?null:driverNameController.text.toString().toLowerCase() )
            .get();

        filteredCarList = querySnapshot.docs
            .map((carDoc) => CarHistoryModel.fromMap(carDoc.data()))
            .toList();
      }

      if (kDebugMode) {
        print(' check pick location is : $dateFormat$endformatdate');
        print(' check pick location is : ${homescreen.selectLocation == 'ALL' ? null :  homescreen.selectLocation}');

      }


      update();
    } catch (e) {
      print('Error fetching filtered data: $e');
    }
  }


  void printFilteredData() {
    filterData();
    for (var car in filteredCarList) {
      // print('Driver Name: ${car.driver_name}');
      // print('Location: ${car.selectLocation}');
      // print('Registration Date: ${car.date}');
      print('---'); // Separator between entries
    }
  }

}