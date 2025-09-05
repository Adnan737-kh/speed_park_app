import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:speed_park_app/core/services/database.dart';

import '../../../core/model/admin/admin_mode.dart';
import '../../../core/services/auth_services.dart';

import '../guest_home_view/view.dart';
import 'state.dart';

class GestLoginLogic extends GetxController {
  final GestLoginState state = GestLoginState();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool visible = true;
  final authService = AuthService();

  void updateVisibility() {
    visible = !visible;
    update();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
      ProgressDialog pD = ProgressDialog(
        context,
        message: const Text('Please wait...'),
        title: const Text('Login in'),
        dismissable: false,
      );

      Admin admin =
      Admin(email: emailController.text, password: passwordController.text);
      pD.show();

      AuthResponse response = await authService.SignInAccount(admin.email, admin.password!, admin);

      if (response.status) {
        pD.dismiss();
        Get.to(() => GuestHomeViewPage());
        debugPrint('Successfully account creat');
      } else {
        Future.delayed(Duration(seconds: 1)).then((value) {
          pD.dismiss();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.message}'),
          ),
        );
      }

      print('response is ' + response.toString());

      return response;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please enter email and password'),
        ),
      );
      return true;
    }
  }
}
