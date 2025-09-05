import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

import '../../../core/constants/colors.dart';
import '../../../core/model/history/car_history_model.dart';
import '../../../core/model/register_car/car_registration.dart';
import '../../../core/model/report_model/report_model.dart';
import '../../../core/services/database.dart';
import '../create_location/logic.dart';
import 'state.dart';

class CreateReportLogic extends GetxController {
  final CreateEmployeState state = CreateEmployeState();
  TextEditingController descController = TextEditingController();
  final Rx<List<CarRegistrationModel>> _car =
  Rx<List<CarRegistrationModel>>([]);
  List<CarRegistrationModel> get car => _car.value;
  final DataBaseServices _repository = DataBaseServices();
  final Rx<List<CarHistoryModel>> _carHistoryModel = Rx<List<CarHistoryModel>>([]);
  List<CarHistoryModel> get historycar => _carHistoryModel.value;
  final progressDialog = ProgressDialogSingleton.createProgressDialog(Get.context!);



  List text = [
    'Code',
    'SP#',
    'Name',
    'Mobile No#',
    'Expiry Date',
    'Email',
  ];
  DateTime currentDateTime = DateTime.now();
  List<String> locations = ['Peshawar','Mardan','Lahore'];
  List<String> usertype = ['Lobby Controller','Validation',];

  Future<void> fetchData() async {
    try {
      // Clear current locations
      locations.clear();

      // Listen to location data stream
      DataBaseServices().getLocationData().listen((locationList) {
        // Extract and add location codes
        locationAssign.clear();
        for (var location in locationList) {
          locationAssign.add(location.code!); // Assuming `LocationModel` has a `code` property
        }

        // Update locations list
        locations.addAll(locationAssign);
        locations.add('All');
        update();

        if (kDebugMode) {
          print('Locations fetched: ${locations.length}');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }


  String? selectLocation;
  void updateSelectLocationField(value) {
    selectLocation = value;
    update();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
   // fetchData();
  }

  // Format date as YYYY-MM-DD
  @override
  void onInit() {
    super.onInit();
    _car.value.clear();
    _carHistoryModel.value.clear();
    fetchData();
     // Set loading to true initially
    // Bind _car to the stream
    _car.bindStream(_repository.getCarRegistrations());
    _carHistoryModel.bindStream(_repository.getCarHistory());
    // Listen to changes in _car
    //fetchData();

  }


  showMoneyCalculation(BuildContext context) async {
    ProgressDialog progressDailog = ProgressDialog(
      context,
      blur: 10,
      title: const Text("Get Collection"),
      message: const Text("Please Wait"),
      onDismiss: () {
        if (kDebugMode) {
          debugPrint("Do something onDismiss");
        }
      },
    );
    progressDailog.show();

    Map<String, double> locationCollectionMap = await _repository.calculateCollectionForLocations(locations);
    if (locationCollectionMap.values.isNotEmpty) {
      progressDailog.dismiss();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Collections'),
          content: SizedBox(
            width: double.minPositive, // Set a minimum width to avoid clipping
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 900), // Set a maximum height
              child: SingleChildScrollView(
                child: Column(
                  children: locationCollectionMap.entries.map((entry) {
                    String location = entry.key;
                    double totalCollection = entry.value;
                    return ListTile(
                      title: Text(location),
                      subtitle: Text('Total Collection: ${totalCollection.toStringAsFixed(2)} AED'),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
    update();
  }


  saveReport(BuildContext context)async{
    if(descController.text.isNotEmpty) {
      String formattedDate = '${currentDateTime.year}-${currentDateTime.month}-${currentDateTime.day}';

      // Format time as 12-hour format with AM/PM
      String formattedTime = TimeOfDay.fromDateTime(currentDateTime).format(context);
      progressDialog.show();
      // ProgressDialogSingleton.getInstance(Get.context!).show();
      ReportModel model=ReportModel(
        description: descController.text.toString(),
        time:formattedTime.toString(),
        date:formattedDate.toString(),


      );

      bool response = await DataBaseServices().addReport(model.toMap());
      if (response) {
        progressDialog.dismiss();
        // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
        Get.snackbar(
          'Done',
          "Report Added Successfully",
          colorText: Colors.black,
          backgroundColor: kPrimary2,
          icon: const Icon(Icons.add_alert),
        );
        descController.clear();
      }

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('please enter report'),
              ),
            );
    }
    update();
  }
}
