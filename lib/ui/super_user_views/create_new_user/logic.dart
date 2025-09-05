import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/model/newuser/new_user.dart';
import '../../../core/services/database.dart';
import 'state.dart';

class CreateNewUserLogic extends GetxController {
  final CreateNewUserState state = CreateNewUserState();
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<String> locations = [];
  List<String> userType = ['Lobby Controller', 'Validation'];
  final String selectedLocation = 'Location Select';
  String? selectCharges;
  String? selectUserType;


  Future<void> fetchData() async {
    try {
      locations.clear();
      DataBaseServices().getLocationData().listen((locationList) {
        locationAssign.clear();
        for (var location in locationList) {
          locationAssign.add(location.code!); // Assuming `LocationModel` has a `code` property
        }
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

  @override
  void onReady() {
    super.onReady();
    fetchData();
  }

  void updateChargesField(value) {
    selectCharges = value;
    update();
  }

  void updateUserTypeField(value) {
    selectUserType = value;
    update();
  }

  List userText = [
    'User name',
    'Email',
    'Password',
  ];

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text(
                  "Processing...",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void dismissProgressDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Dismiss the dialog
    }
  }

  void saveNewUser(BuildContext context) async {
    if (userController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        selectUserType != null &&
        selectCharges != null) {
      // Show progress dialog
      showProgressDialog(context);

      // Create a NewUserModel object
      NewUserModel model = NewUserModel(
        username: userController.text.trim(),
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim(),
        location: selectCharges!,
        userTyoe: selectUserType!,
      );

      try {
        // Save user to Firestore
        bool response = await DataBaseServices().addNewUser(model.toMap());

        if (response) {
          // Dismiss progress dialog
          dismissProgressDialog(context);


          // Show success message
          Get.snackbar(
            'Success',
            "New User Added Successfully",
            colorText: Colors.black,
            backgroundColor: kPrimary2,
            icon: const Icon(Icons.check_circle),
          );

          // Clear input fields
          userController.clear();
          emailController.clear();
          passwordController.clear();
        }
      } catch (e) {
        // Dismiss progress dialog
        dismissProgressDialog(context);

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add user: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all user details'),
        ),
      );
    }

    update(); // Ensure the state is updated
  }
}
