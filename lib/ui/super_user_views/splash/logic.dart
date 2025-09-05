import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../role_selection_view.dart';
import '../../../widgets/qr_code_widget.dart';
import '../../lobby_controller_views/lobby_login/logic.dart';
import '../../lobby_controller_views/lobby_login/view.dart';
import '../../lobby_controller_views/lobby_main_menu/view.dart';
import '../../onboard/onboard._view.dart';
import '../../validation_views/validation_login/view.dart';
import '../login/view.dart';
import '../main_menu/view.dart';
import '../superuser/view.dart';
import 'state.dart';

// class SplashLogic extends GetxController {
//   final SplashState state = SplashState();
//   double opacity = 0.0;
//
//   void updateOpacity() {
//     opacity = 1.0;
//     update();
//   }
//
//   late Rx<User?> _user;
//
//   @override
//   void onReady() {
//     super.onReady();
//     _user = Rx<User?>(FirebaseAuth.instance.currentUser);
//
//     _user.bindStream(FirebaseAuth.instance.authStateChanges());
//     Get.offAll(() => RoleSelectionView());
//
//     // Always navigate to RoleSelectionView, regardless of user state
//     ever(_user, (_) {
//     });
//   }
// }

class SplashLogic extends GetxController {
  final SplashState state = SplashState();

  double opacity = 0.0;

  void updateOpacity() {
    opacity = 1.0;
    update();
  }

  //User State Persistence

  late Rx<User?> _user;
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);

    _user.bindStream(FirebaseAuth.instance.authStateChanges());

    ever(_user, _setInitialView);
  }

  _setInitialView(User? user) {
    if (user == null) {
      Get.offAll(() => const OnBoardView());
    } else {
      Get.offAll(() => RoleSelectionView());
    }
  }
}
