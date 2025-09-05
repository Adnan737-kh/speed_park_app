import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/model/location/location_model.dart';
import '../../../core/services/database.dart';
import '../create_location/logic.dart';
import 'state.dart';

class ShowPreviousRecordsLogic extends GetxController {
  List text = [
    'Code',
    'Description',
    'No. Of Staff',
    'Office Type',
    'Timing Start',
    'Timings End',
    'Location Type',
    'Filter',
  ];
  List<String> timings = [
    '00:00',
    '01:00',
    '02:00',
    '03:00',
    '04:00',
    '05:00',
    '06:00',
    '07:00',
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
    '23:00'
  ];

  String? fromTiming;
  String? toTiming;
  TextEditingController codeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController staffController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final progressDialog = ProgressDialogSingleton.createProgressDialog(Get.context!);


  final ShowPreviousRecordsState state = ShowPreviousRecordsState();
  var locationData = <LocationModel>[].obs;
  Future<void> fetchData() async {
    DataBaseServices().getLocationData().listen((data) {
      locationData.assignAll(data);
      update();
    });
  }

  @override
  void onInit() {
    super.onInit();

    // Add a listener to the amountController
    amountController.addListener(() {
      // Calculate the total amount with tax when the amount changes
      calculateTotalAmountWithTax();
    });
    perHourController.addListener(() {
      // Calculate the total amount with tax when the amount changes
      calculateTotalAmountWithTax();
    });

    // ... Other initialization code ...
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    fetchData();
  }

  var items = ['Normal', "Paid"];
  String? _selectedValue;
  String? get selectedValue => _selectedValue;

  void updateField(value) {
    _selectedValue = value;
    update();
  }

  var charges = ["Per Services", "Per hour"];
  String? selectCharges;
  void updateChargesField(value) {
    selectCharges = value;
    update();
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController totalAmountWithTaxController = TextEditingController();
  TextEditingController perHourController = TextEditingController();
  var taxCharges = ["Tax Inclusive", "Tax Exclusive"];
  String? selectTaxCharges;
  void updateTaxChargesField(value) {
    selectTaxCharges = value;
    update();
  }

  String? _selectedPerServicesValue;
  String? get selectedPerServicesValue => _selectedPerServicesValue;
  void updatePerServiceField(value) {
    _selectedPerServicesValue = value;
    update();
  }

  void calculateTotalAmountWithTax() {
    final double amount = double.tryParse(amountController.text) ?? 0.0;
    final double perHourAmount = double.tryParse(perHourController.text) ?? 0.0;
    const double taxPercentage = 5.0;

    // Calculate the total amount before tax
    final double totalAmount = amount + perHourAmount;

    // Calculate the tax amount on the total amount
    final double totalTaxAmount = (totalAmount * taxPercentage) / 100;

    // Calculate the total amount with tax
    final double totalAmountWithTax = totalAmount + totalTaxAmount;

    // Update the respective text controllers
    taxController.text = totalTaxAmount
        .toStringAsFixed(2); // Format total tax amount with two decimal places
    totalAmountWithTaxController.text =
        totalAmountWithTax.toStringAsFixed(2); // Format total amount with tax
  }

  updateLocation(
      {required String uid,
      required String description,
      required String location,
      required BuildContext context,
      required LocationModel model}) async {
    try {
      progressDialog.show();
      // ProgressDialogSingleton.getInstance(Get.context!).show();
      LocationModel locationModel = LocationModel(
        code: locationController.text.isNotEmpty
            ? locationController.text.toString()
            : model.code,
        desc: descController.text.isNotEmpty
            ? descController.text.toString()
            : model.desc,
        staff: staffController.text.isNotEmpty
            ? staffController.text.toString()
            : model.staff,
        location: locationController.text.isNotEmpty
            ? locationController.text.toString()
            : model.location,
        selectLocation: selectedValue != null
            ? selectedValue.toString()
            : model.selectLocation,
        selectCharges: selectCharges != null
            ? selectCharges.toString()
            : model.selectCharges,
        taxCharge: selectTaxCharges != null
            ? selectTaxCharges.toString()
            : model.taxCharge,
        perHour: perHourController.text.isNotEmpty
            ? perHourController.text.toString()
            : model.perHour,
        totalAmountPerHour: amountController.text.isNotEmpty
            ? amountController.text.toString()
            : model.totalAmountPerHour,
        totalAmountWithTax: totalAmountWithTaxController.text.isNotEmpty
            ? totalAmountWithTaxController.text.toString()
            : model.totalAmountWithTax,
        amount: amountController.text.isNotEmpty
            ? amountController.text.toString()
            : model.amount,
        uid: model.uid,
      );
      final response =
          await DataBaseServices().updateLocation(uid, locationModel.toMap());
      print(response);
      if (response) {
        progressDialog.dismiss();
        // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
        Navigator.pop(context);
        Get.snackbar(
          'Done',
          "Location Update Successfully",
          colorText: Colors.black,
          backgroundColor: kPrimary2,
          icon: const Icon(Icons.add_alert),
        );
        descController.clear();
        locationController.clear();
        fetchData();
      }
      if (!response) {
        progressDialog.dismiss();
        // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
        Get.snackbar(
          'Sorry',
          "Location is not update",
          colorText: Colors.black,
          backgroundColor: kPrimary2,
          icon: const Icon(Icons.add_alert),
        );
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    update();
  }

  delete(String uid) async {
    progressDialog.show();
    // ProgressDialogSingleton.getInstance(Get.context!).show();
    final response = await DataBaseServices().deleteLocation(uid);
    if (response) {
      progressDialog.dismiss();
      // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
      fetchData();
    } else {
      progressDialog.show();
      // ProgressDialogSingleton.getInstance(Get.context!).show();
    }
    update();
  }
}
