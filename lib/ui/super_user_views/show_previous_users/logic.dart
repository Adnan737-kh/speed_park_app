import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/model/newuser/new_user.dart';
import '../../../core/services/database.dart';
import '../create_location/logic.dart';
import 'state.dart';

class ShowPreviousUsersLogic extends GetxController {
  final ShowPreviousUsersState state = ShowPreviousUsersState();

  TextEditingController userController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController projectController = TextEditingController();
  TextEditingController userLocation = TextEditingController();
  TextEditingController userType = TextEditingController();
  TextEditingController userSelectedLocation = TextEditingController();
   // String? userSelectedLocation;
  final progressDialog = ProgressDialogSingleton.createProgressDialog(Get.context!);
  List<String> locations = ['Peshawar','Mardan','Lahore'];


  List<String> usertype = [
    'Lobby Controller',
    'Validation',
  ];
  List userText = [
    'User',
    'Location',
    'Project',
  ];
  String? selectUserType;
  void updateUserTypeField(value) {
    userType.text = value;
    update();
  }

  void updateUserLocation(value) {
    userSelectedLocation = value;
    update();
  }

  @override
  void onReady() {
    super.onReady();
    getLocations();
    fetchData();
  }

  var newUserData = <NewUserModel>[].obs;
  // Future<void> fetchData() async {
  //   DataBaseServices().getUserDataStream().listen((data) {
  //     newUserData.assignAll(data);
  //     update();
  //   });
  // }

  void fetchData() {
    DataBaseServices().getUserData().listen((data) {
      newUserData.assignAll(data);
      update();
    });
  }



  Future<void> getLocations() async {
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

  updateUser({String? uid, BuildContext? context,String? usernames,
    String? email,String? password,String? userTypes,String? userLocations}) async {
    try {
      if (userController.text.isNotEmpty &&
          locationController.text.isNotEmpty &&
          projectController.text.isNotEmpty &&
          userLocation.text.isNotEmpty) {
        progressDialog.show();
        // ProgressDialogSingleton.getInstance(Get.context!).show();
        final response = await DataBaseServices().updateUser(
            uid!,
            userController.text.isNotEmpty?userController.text:usernames.toString(),
            locationController.text.isNotEmpty?locationController.text.toString():email.toString(),
            projectController.text.isNotEmpty? projectController.text.toString():password.toString(),
            userType.text.isNotEmpty?userType.text.toString():userTypes.toString(),
            userSelectedLocation.text.isNotEmpty?userSelectedLocation.text.toString():userSelectedLocation.toString(),
        );
        if (response) {
          // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
          progressDialog.dismiss();
          Navigator.pop(context!);
          Get.snackbar(
            'Done',
            "User Update Successfully",
            colorText: Colors.black,
            backgroundColor: kPrimary2,
            icon: const Icon(Icons.add_alert),
          );
          userController.clear();
          locationController.clear();
          projectController.clear();
          fetchData();
        }

        update();
      } else {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(
            content: Text('please enter record'),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }
  delete(String uid)async{
    progressDialog.show();
    // ProgressDialogSingleton.getInstance(Get.context!).show();
    final response = await DataBaseServices().deleteUser(uid);
    if(response){
      progressDialog.dismiss();
      // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
    }
    else{
      progressDialog.show();
      // ProgressDialogSingleton.getInstance(Get.context!).show();
    }
    update();
  }
}
