import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:speed_park_app/core/services/database.dart';

import '../lobby_main_menu/view.dart';
import 'state.dart';

class LobbyLoginLogic extends GetxController {
  final LobbyLoginState state = LobbyLoginState();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool visible = true;

  // Reactive variable for storing user data
  RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

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

  Future<Object> lobbyLogin(BuildContext context) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        message: const Text('Please wait...'),
        title: const Text('Logging in'),
        dismissable: false,
      );
      progressDialog.show();

      try {
        final response = await DataBaseServices().lobbyAndValidationLogin(
          email: emailController.text.toString(),
          password: passwordController.text.toString(),
          usertype: 'Lobby Controller',
        );

        if (response) {
          final userDoc = await FirebaseFirestore.instance
              .collection('newuser')
              .where('email', isEqualTo: emailController.text.toString())
              .limit(1)
              .get();

          if (userDoc.docs.isNotEmpty) {
            userData.value = userDoc.docs.first.data(); // Store user data in the reactive variable
            print("User Data: $userData");

            progressDialog.dismiss();
            Get.to(() => LobbyMainMenuPage());
          } else {
            progressDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User not found in database.'),
              ),
            );
          }
        } else {
          Future.delayed(const Duration(seconds: 1)).then((value) {
            progressDialog.dismiss();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
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
        const SnackBar(
          content: Text('Please enter email and password'),
        ),
      );
      return false;
    }
  }
}
