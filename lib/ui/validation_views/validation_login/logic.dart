import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:speed_park_app/core/services/database.dart';

import '../validation_main_menu_view/view.dart';
import 'state.dart';

class ValidationLoginLogic extends GetxController {
  final ValidationLoginState state = ValidationLoginState();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Reactive variable for storing user data
  RxMap<String, dynamic> validationUserData = <String, dynamic>{}.obs;

  bool visible = true;

  void updateVisibility() {
    visible = !visible;
    update();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  clearController() {
    emailController.clear();
    passwordController.clear();
  }

  Future<Object> signUp(BuildContext context) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        message: const Text('Please wait...'),
        title: const Text('Login in'),
        dismissable: false,
      );

      progressDialog.show();
      try {
        final response = await DataBaseServices().lobbyAndValidationLogin(
            email: emailController.text.toString(),
            password: passwordController.text.toString(),
            usertype: 'validation'.tr);

        if (response) {
          final userDoc = await FirebaseFirestore.instance
              .collection('new_user'.tr)
              .where('email_hint'.tr, isEqualTo: emailController.text.toString())
              .limit(1)
              .get();

          if (userDoc.docs.isNotEmpty) {
            validationUserData.value = userDoc.docs.first
                .data(); // Store user data in the reactive variable
            print("User Data: $validationUserData");

            progressDialog.dismiss();
            Get.to(() => ValidationMainMenuViewPage());
          } else {
            progressDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                content: Text('user_not_found'.tr),
              ),
            );
          }
        } else {
          Future.delayed(const Duration(seconds: 1)).then((value) {
            progressDialog.dismiss();
          });
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('invalid_email_or_password'.tr),
            ),
          );
        }
        return response;
      } catch (e) {
        progressDialog.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('enter_email_and_password'.tr),
        ),
      );
      return false;
    }
  }
}
