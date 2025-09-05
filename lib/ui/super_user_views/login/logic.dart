import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

import '../../../core/model/admin/admin_mode.dart';
import '../../../core/services/auth_services.dart';
import '../../../core/services/database.dart';
import '../main_menu/view.dart';
import 'state.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _visible = false;
  bool get visible => _visible;

  final authService = AuthService();

  void updateVisibility() {
    _visible = !_visible;
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

  // Future<Object> signUp(BuildContext context) async {
  //   if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
  //     ProgressDialog pD = ProgressDialog(
  //       context,
  //       message: const Text('Please wait...'),
  //       title: const Text('Login in'),
  //       dismissable: false,
  //     );
  //
  //     Admin admin =
  //         Admin(email: emailController.text, password: passwordController.text);
  //     pD.show();
  //
  //     AuthResponse response =
  //         await authService.SignInAccount(admin.email, admin.password!, admin);
  //
  //     if (response.status) {
  //       pD.dismiss();
  //
  //       Get.to(() => MainMenuPage());
  //     } else {
  //       Future.delayed(const Duration(seconds: 1)).then((value) {
  //         pD.dismiss();
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(response.message),
  //         ),
  //       );
  //     }
  //
  //     if (kDebugMode) {
  //       print('response is $response');
  //     }
  //
  //     return response;
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('please enter email and password'),
  //       ),
  //     );
  //     return true;
  //   }
  // }

  Future<Object> superUserLogin(BuildContext context) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      ProgressDialog pD = ProgressDialog(
        context,
        message: const Text('Please wait...'),
        title: const Text('Login in'),
        dismissable: false,
      );

      // Admin admin =
      // Admin(email: emailController.text, password: passwordController.text);
      pD.show();

      final response =
      await DataBaseServices().superUserLogin(email:emailController.text.toString(),
          password:passwordController.text.toString(),usertype: 'super user' );

      if (response) {
        pD.dismiss();
        Get.to(() => MainMenuPage());
        debugPrint('Login Successfully');
      } else {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          pD.dismiss();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter valid email and password'),
          ),
        );
      }

      print('response is $response');

      return response;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('please enter email and password'),
        ),
      );
      return true;
    }
  }
}
