import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/model/superuser/super_user_model.dart';
import '../../../core/services/database.dart';
import '../create_location/logic.dart';
import 'create_super_user_state.dart';

class CreateSuperUserLogic extends GetxController{

  final _firebaseAuth = FirebaseAuth.instance;

  final CreateSuperUserState state = CreateSuperUserState();
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<String> usertype = ['super user'];
  final progressDialog = ProgressDialogSingleton.createProgressDialog(Get.context!);



  String? selectCharges;
  String? selectUserType;

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

  createSuperUser(BuildContext context) async {
    if (userController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        selectUserType != null &&
        selectUserType!.isNotEmpty) {
      // Show progress dialog
      progressDialog.show();
      // ProgressDialogSingleton.getInstance(Get.context!).show();
      try {
        // Create a new user in Firebase Authentication
        // await _firebaseAuth.createUserWithEmailAndPassword(
        //   email: emailController.text.toLowerCase().toString(),
        //   password: passwordController.text.toString(),
        // );

        // Create the super user model
        SuperUserModel model = SuperUserModel(
          username: userController.text.toString(),
          email: emailController.text.toLowerCase().toString(),
          password: passwordController.text.toString(),
          userType: selectUserType.toString(),
        );

        if (kDebugMode) {
          print("model user type ${selectUserType.toString()}");
        }
        // Save user details to Firestore
        bool response = await DataBaseServices().createSuperUser(model.toMap());
        if (response) {
          // Dismiss progress dialog
          progressDialog.dismiss();
          // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
          // Navigator.push(context, MaterialPageRoute(builder: (context) => LobbyMainMenuPage(),));
          // Show success snackbar
          Get.snackbar(
            'Success',
            "Super user account created",
            colorText: Colors.black,
            backgroundColor: kPrimary2,
            icon: const Icon(Icons.check_circle));

          // Clear input fields
          userController.clear();
          emailController.clear();
          passwordController.clear();
        }
      } on FirebaseAuthException catch (e) {
        // Dismiss progress dialog
        // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
        progressDialog.dismiss();
        // Check the error code and show a snackbar for email already in use
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The email address is already in use by another account.'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Handle any other unexpected errors
        progressDialog.dismiss();
        // ProgressDialogSingleton.getInstance(Get.context!).dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // If input fields are empty, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all the details'),
          backgroundColor: Colors.orange,
        ),
      );
    }

    update();
  }

}


