import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

import '../../../core/model/admin/admin_mode.dart';
import '../../../core/services/auth_services.dart';
import '../lobby_main_menu/view.dart';
import 'state.dart';

class LobbySignUpLogic extends GetxController {
  final LobbySignUpState state = LobbySignUpState();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authService = AuthService();
  final formKey = GlobalKey<FormState>();
  bool visible = false;

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
        title: const Text('Signup in'),
        dismissable: false,
      );

      Admin admin =
      Admin(email: emailController.text, password: passwordController.text);
      pD.show();

      AuthResponse response =
      await authService.createAccount(admin.email, admin.password!, admin);

      if (response.status) {
        pD.dismiss();
        Get.to(() => LobbyMainMenuPage());
        debugPrint('Successfully account creat');
      } else {
        Future.delayed(Duration(seconds: 1)).then((value) {
          pD.dismiss();
        });
      }
      //Get.to(() => WebScreenLayoutView());
      print('response is ' + response.toString());

      return response;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please enter email and password'),
        ),
      );
      return true;
    }
  }
}
